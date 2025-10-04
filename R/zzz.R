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

##
resp_raw <- function(x) {
  jsonlite::fromJSON(
    httr::content(x, as = "text", encoding = "UTF-8"),
    simplifyVector = FALSE, flatten = TRUE
  )
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


resp_to_spatial <- function(x, as_sf = FALSE, keep_geom = TRUE) {
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
  paste0(
    "* Current taxonomic IDs coverage for nodes of this network: \n  --> ",
    "ITIS: ", percent_id(x$taxonomy.tsn), "%, ",
    "BOLD: ", percent_id(x$taxonomy.bold), "%, ",
    "EOL: ", percent_id(x$taxonomy.eol), "%, ",
    "COL: ", percent_id(x$taxonomy.col), "%, ",
    "GBIF: ", percent_id(x$taxonomy.gbif), "%, ",
    "NCBI: ", percent_id(x$taxonomy.ncbi), "%\n"
  )
}

print_pub_info <- function(x) {
  paste0("* Published in ref #", x$id, " DOI:", x$doi)
}

print_net_info <- function(net_id, dat_id, descr, n_edg, n_nod) {
  paste0(
    "* Network #", net_id, " included in dataset #", dat_id, "\n",
    "* Description: ", descr, "\n",
    "* Includes ", n_edg, " edges and ", n_nod, " nodes \n"
  )
}
