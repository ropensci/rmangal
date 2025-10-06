#' rmangal
#'
#' A programmatic interface to the Mangal API <https://mangal-interactions.github.io/mangal-api/>.
#'
#' @docType package
#' @importFrom methods is
#' @name rmangal
#' @keywords internal
"_PACKAGE"


# NULL to NA
null_to_na <- function(x) {
  if (is.list(x)) {
    lapply(x, null_to_na)
  } else {
    ifelse(is.null(x), NA, x)
  }
}

## Response => data.frame
resp_to_df <- function(x) {
  if (is.null(x)) {
    x
  } else {
    do.call(
      what = rbind,
      lapply(
        x,
        function(y) null_to_na(y) |> as.data.frame()
      )
    )
  }
}

# flatten + fill
resp_to_df_flt <- function(x) {
  x <- null_to_na(x)
  ldf <- lapply(
    lapply(x, function(x) as.data.frame(x, stringsAsFactors = FALSE)),
    jsonlite::flatten
  )
  vnm <- unique(unlist(lapply(ldf, names)))
  ldf2 <- lapply(ldf, fill_df, vnm)
  do.call(rbind, ldf2)
}

fill_df <- function(x, nms) {
  id <- nms[!nms %in% names(x)]
  if (length(id)) x[id] <- NA
  x
}


resp_to_spatial <- function(x, as_sf = FALSE) {
  if (is.null(x)) {
    NA
  } else {
    dat <- cbind(
      x[!names(x) %in% "geom"] |> as.data.frame(),
      handle_geom(x)
    )
    if (as_sf) {
      resp_to_sf(dat)
    } else {
      dat
    }
  }
}

handle_geom <- function(x) {
  if (is.null(x$geom) || anyNA(x$geom)) {
    data.frame(
      geom_type = NA_character_,
      geom_lon = NA_real_,
      geom_lat = NA_real_
    )
  } else {
    tmp <- matrix(unlist(x$geom$coordinates), ncol = 2, byrow = TRUE)
    # names(tmp) <- paste0("geom_", c("lon", "lat"))
    out <- data.frame(
      geom_type = x$geom$type,
      stringsAsFactors = FALSE
    )
    out$geom_lon <- list(tmp[, 1])
    out$geom_lat <- list(tmp[, 2])
    out
  }
}

## Response => spatial -- sf required
resp_to_sf <- function(dat) {
  stop_if_missing_sf()
  if (nrow(dat) == 1) {
    spd <- switch_sf(dat)
  } else {
    spd <- apply(dat, 1, switch_sf)
  }
  sf::st_sf(
    dat[names(dat)[!grepl("geom_", names(dat))]],
    geom = sf::st_sfc(spd),
    crs = 4326, stringsAsFactors = FALSE
  )
}

## Build sf object based on geom.type
switch_sf <- function(x) {
  if (is.na(x$geom_type)) {
    sf::st_point(matrix(NA_real_, ncol = 2))
  } else {
    co <- cbind(
      as.numeric(unlist(x$geom_lon)),
      as.numeric(unlist(x$geom_lat))
    )
    switch(x$geom_type,
      Point = sf::st_point(co),
      Polygon = sf::st_polygon(list(co)),
      stop("Only `Point` and `Polygon` are supported.")
    )
  }
}


stop_if_missing_sf <- function(pkg = "sf") {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop("sf should be installed to use this feature", call. = FALSE)
  }
}

get_from_fkey <- function(endpoint, verbose = TRUE, ...) {
  rmangal_request(
    endpoint = endpoint, query = list(...), verbose = verbose
  )$body |> resp_to_df()
}

get_from_fkey_flt <- function(endpoint, verbose = TRUE, ...) {
  rmangal_request(
    endpoint = endpoint, query = list(...), verbose = verbose
  )$body |> resp_to_df_flt()
}



# message


percent_id <- function(y) round(100 * sum(!is.na(y)) / length(y))

print_taxo_ids <- function(x) {
  cli::cli_text(
    "{cli::symbol$bullet} Taxonomic IDs coverage for nodes:"
  )
  cli::cli_text(
    "{cli::col_cyan('ITIS')}: {percent_id(x$taxonomy.tsn)}%, ",
    "{cli::col_cyan('BOLD')}: {percent_id(x$taxonomy.bold)}%, ",
    "{cli::col_cyan('EOL')}: {percent_id(x$taxonomy.eol)}%, ",
    "{cli::col_cyan('COL')}: {percent_id(x$taxonomy.col)}%, ",
    "{cli::col_cyan('GBIF')}: {percent_id(x$taxonomy.gbif)}%, ",
    "{cli::col_cyan('NCBI')}: {percent_id(x$taxonomy.ncbi)}%"
  )
  invisible()
}

print_pub_info <- function(x) {
  cli::cli_text(
    "{cli::symbol$bullet} Published in reference {cli::col_blue('#{x$id}')} ",
    "DOI: {cli::col_grey(x$doi)}"
  )
  invisible()
}

print_net_info <- function(net_id, dat_id, descr, n_edg, n_nod) {
  cli::cli_h2("Network {cli::col_blue('#{net_id}')}")
  cli::cli_text(
    "{cli::symbol$bullet} Dataset: {cli::col_blue('#{dat_id}')}"
  )
  cli::cli_text(
    "{cli::symbol$bullet} Description: {descr}"
  )
  cli::cli_text(
    "{cli::symbol$bullet} Size: {cli::col_green(n_edg)} edge{?s}, ",
    "{cli::col_green(n_nod)} node{?s}"
  )
  invisible()
}
