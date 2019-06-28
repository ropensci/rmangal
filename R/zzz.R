#' rmangal
#'
#' A programmatic interface to the Mangal API <https://mangal-wg.github.io/mangal-api//>.
#'
#' @docType package
#' @name rmangal
#' @keywords internal
"_PACKAGE"

# HELPER FUNCTIONS
# Basic
server <- function() "http://poisotlab.biol.umontreal.ca"
# server <- function() "http://localhost:8080" # dev purpose
base <- function() "/api/v2"
# bearer <- function() ifelse(file.exists(".httr-oauth"),
#   as.character(readRDS(".httr-oauth")), NA)
ua <- httr::user_agent("rmangal")

# Endpoints
endpoints <- function() {
  list(
    dataset = "/dataset",
    environment = "/environment",
    interaction = "/interaction",
    network = "/network",
    node = "/node",
    reference = "/reference",
    attribute = "/attribute",
    taxonomy = "/taxonomy",
    trait = "/trait"
  )
}

# Common spatial columns in mangal-db
sf_columns <- function(x) c("geom.type", "geom.coordinates")

# NULL to NA
null_to_na <- function(x) {
    if (is.list(x)) {
      lapply(x, null_to_na)
    } else {
      ifelse(is.null(x), NA, x)
    }
}

## Response => raw
resp_raw <- function(x) httr::content(x, as = "parsed", encoding = "UTF-8")

## Response => data.frame
resp_to_df <- function(x) {
  if (is.null(x))
    x else do.call(rbind, lapply(null_to_na(x),
      function(x) as.data.frame(x, stringsAsFactors = FALSE)))
}

# flatten + fill
resp_to_df_flt <- function(x) {
  x <- null_to_na(x)
  ldf <- lapply(
    lapply(x, function(x) as.data.frame(x, stringsAsFactors = FALSE)),
    jsonlite::flatten)
  vnm <- unique(unlist(lapply(ldf, names)))
  ldf2 <- lapply(ldf, fill_df, vnm)
  do.call(rbind, ldf2)
}

fill_df <- function(x, nms) {
  id <- nms[!  nms %in% names(x)]
  if (length(id)) x[id] <- NA
  x
}

## Response => spatial
resp_to_spatial <- function(x) {
  if (is.null(x)) {
    x
  } else {
      suppressWarnings(do.call(rbind, lapply(null_to_na(x), switch_sf)))
  }
}

## Build sf object based on geom.type
switch_sf <- function(tmp) {
  df_nogeom <- as.data.frame(tmp[names(tmp) != "geom"],
    stringsAsFactors = FALSE)
  if (is.na(tmp$geom)) {
    sf::st_sf(df_nogeom, geom = sf::st_sfc(sf::st_point(
      matrix(NA_real_, ncol = 2)), crs = 4326))
  } else {
    co <- matrix(unlist(tmp$geom$coordinates), ncol = 2, byrow = TRUE)
    switch(
      tmp$geom$type,
      Point = sf::st_sf(df_nogeom, geom = sf::st_sfc(sf::st_point(co),
        crs = 4326)),
      Polygon = sf::st_sf(df_nogeom, geom = sf::st_sfc(sf::st_polygon(
        list(co)), crs = 4326)),
      stop("Only `Point` and `Polygon` are supported.")
    )
  }
}

#' Get entries based on foreign key
#'
#' @param endpoint `character` API entry point
#' @param ... foreign key column name with the id
#' @examples
#'\dontrun{
#' get_from_fkey(endpoints()$node, network_id = 926)
#'}
#' @return
#' Object returned by [rmangal::get_gen()]
#' @details
#' See endpoints available with `endpoints()`
#' @keywords internal

get_from_fkey <- function(endpoint, verbose = TRUE, ...) {
  query <- list(...)
  # print(get_gen(endpoint = endpoint, query = query)$body)
  resp_to_df(
    get_gen(endpoint = endpoint, query = query, verbose = verbose)$body
  )
}

get_from_fkey_net <- function(endpoint, verbose = TRUE, ...) {
  query <- list(...)
  resp_to_spatial(
    get_gen(endpoint = endpoint, query = query, verbose = verbose)$body
  )
}

get_from_fkey_flt <- function(endpoint, verbose = TRUE, ...) {
  query <- list(...)
  resp_to_df_flt(
    get_gen(endpoint = endpoint, query = query, verbose = verbose)$body
  )
}



#' Generic API function to retrieve several entries
#'
#' @param endpoint `character` API entry point
#' @param query `list` list of parameters passed to the API
#' @param limit `integer` number of entries return by the API (max: 1000)
#' @param verbose `logical` print API code status on error; default: `TRUE`
#' @param ... Further named parameters, see [httr::GET()].httr options, see [httr::GET()].
#' @return
#' Object of class `mgGetResponses`
#' @details
#' See endpoints available with `endpoints()`
#' @keywords internal

get_gen <- function(endpoint, query = NULL, limit = 100, verbose = TRUE,...) {

  url <- httr::modify_url(server(), path = paste0(base(), endpoint))
  query <- as.list(query)

  # Add number of entries to the param
  query$count <- limit

  # First call used to set pages
  resp <- httr::GET(url,
      config = httr::add_headers(`Content-type` = "application/json"), ua,
      query = query, ...)

  # Prep output object
  responses <- list()
  errors <- NULL

  # Get # pages
  tmp <- unlist(strsplit(httr::headers(resp)$"content-range", split = "\\D"))
  rg <- as.numeric(tmp[grepl("\\d", tmp)])
  pages <- rg[3L] %/% limit

  # Loop over pages
  for (page in 0:pages) {
    query$page <- page
    resp <- httr::GET(url,
      config = httr::add_headers(`Content-type` = "application/json"), ua,
      query = query, ...)

    if (httr::http_error(resp)) {
      if (verbose) msg_request_fail(resp)
      responses[[page + 1]] <- list(body = NULL, response = resp)
      errors <- append(errors, page + 1)
    } else {
      responses[[page + 1]] <- list(body = resp_raw(resp), response = resp)
    }
  }
  #
  if (!is.null(errors))
    warning("Failed request(s) for page(s): ", paste0(errors, ", "))

  # check error here if desired;
  out <- list(
    body = unlist(purrr::map(responses, "body"), recursive = FALSE),
    response = purrr::map(responses, "response")
  )
  class(out) <- "mgGetResponses"
  out
}


#' Generic API function to retrieve singletons
#'
#' @param endpoint `character` API entry point.
#' @param ids `numeric` vector of ids.
#' @param verbose `logical` print API code status on error; default: `TRUE`
#' @param ... httr options, see [httr::GET()].
#' @return
#' Object of class `mgGetResponses`
#' @details
#' See endpoints available with `endpoints()`
#' @keywords internal
get_singletons <- function(endpoint = NULL, ids = NULL, verbose = FALSE,
   ...) {

  stopifnot(!is.null(endpoint) & !is.null(ids))
  # Prep output object
  responses <- list(body = list(), response = list())
  errors <- NULL

  # Loop over ids
  for (i in seq_along(ids)) {
    # Set url
    url <- httr::modify_url(server(), path = paste0(base(), endpoint, "/",
      ids[i]))

    # Call on the API
    resp <- httr::GET(url,
      config = httr::add_headers(`Content-type` = "application/json"), ua, ...)

    if (httr::http_error(resp)) {
      if (verbose) msg_request_fail(resp)
      errors <- append(errors, ids[i])
    } else {
      # coerce body to output desired
      responses$body[[i]] <- resp_raw(resp)
      responses$response[[i]] <- resp
    }
  }
  if (!is.null(errors))
    warning("Failed request(s) for id(s): ", paste0(errors, ", "))

  class(responses) <- "mgGetResponses"
  responses
}



# PRINT/MESSAGES HELPERS

handle_query <- function(query) {
  if (is.character(query))
    query <- list(q = query)
  if (!is.list(query))
    stop("`query` should either be a list or a character string.")
  if (length(query) > 1)
    warning("Only the first element of the list is considered.")
  query
}

msg_request_fail <- function(resp) {
  message(sprintf("API request failed (%s): %s",
    httr::status_code(resp), httr::content(resp)$message))
}


handle_query <- function(query, names_available) {
  if (is.character(query)) return(list(q = query))
  if (!is.list(query))
    stop("`query` should either be a list or a character string.",
      call. = FALSE)
  if (length(query) > 1) {
    warning("Only the first element of the list is considered.", call. = FALSE)
    query <- query[1]
  }
  if (! names(query) %in% names_available)
    stop("Only ", paste(names_available, collapse = ", "),
      " are valid names for custom queries.", call. = FALSE)
  query
}
# Remove ==> other message "should be named"



percent_id <- function(y) round(100*sum(!is.na(y))/length(y))

print_taxo_ids <- function(x) {

  paste0(
    "* Percent of nodes with taxonomic IDs from external sources: \n  --> ",
    percent_id(x$taxonomy.tsn), "% ITIS, ",
    percent_id(x$taxonomy.bold), "% BOLD, ",
    percent_id(x$taxonomy.eol), "% EOL, ",
    percent_id(x$taxonomy.col), "% COL, ",
    percent_id(x$taxonomy.gbif), "% GBIF, ",
    percent_id(x$taxonomy.ncbi), "% NCBI\n"
  )
}
