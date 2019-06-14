
# Basic
server <- function() "http://poisotlab.biol.umontreal.ca"
# server <- function() "http://localhost:8080" # dev purpose
base <- function() "/api/v2"
bearer <- function() ifelse(file.exists(".httr-oauth"),
  as.character(readRDS(".httr-oauth")), NA)
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
resp_raw <- function(resp) {
 httr::content(resp, as = "parsed", encoding = "UTF-8")
}

## Response => data.frame
resp_to_df <- function(x) {
  if (is.null(x))
    x else do.call(rbind, lapply(null_to_na(x), as.data.frame))
}

# flatten + fill
resp_to_df_flt <- function(x) {
  x <- null_to_na(x)
  ldf <- lapply(lapply(x, as.data.frame), jsonlite::flatten)
  vnm <- unique(unlist(lapply(ldf, names)))
  ldf2 <- lapply(ldf, fill_df, vnm)
  do.call(rbind, ldf2)
}

fill_df <- function(x, nms) {
  id <- nms[!  nms %in% names(x)]
  if (length(id)) {
    x[id] <- NA
  }
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

switch_sf <- function(tmp) {
  df_nogeom <- as.data.frame(tmp[names(tmp) != "geom"])
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

get_from_fkey <- function(endpoint, ...) {
  query <- list(...)
  # print(get_gen(endpoint = endpoint, query = query)$body)
  resp_to_df(get_gen(endpoint = endpoint, query = query)$body)
}

get_from_fkey_net <- function(endpoint, ...) {
  query <- list(...)
  resp_to_spatial(get_gen(endpoint = endpoint, query = query)$body)
}

get_from_fkey_flt <- function(endpoint, ...) {
  query <- list(...)
  resp_to_df_flt(get_gen(endpoint = endpoint, query = query)$body)
}



#' Generic API function to retrieve several entries
#'
#' @param endpoint `character` API entry point
#' @param query `list` list of parameters passed to the API
#' @param limit `integer` number of entries return by the API (max: 1000)
#' @param flatten `logical` flatten nested data.frame, see [jsonlite::flatten()]; default: `TRUE`
#' @param output `character` output type (`data.frame`, `list`, `spatial`, `raw`) return (default: data.frame)
#' @param verbose `logical` print API code status on error; default: `TRUE`
#' @param ... httr options, see [httr::GET()]
#' @return
#' Object of class `mgGetResponses` whithin each level is a page.
#' Each item of the list `mgGetResponses` corresponds to an API call. Each call returns an object:
#' - `getSuccess` which is a list with the body [httr::content()] and the server response [httr::response()].
#' - `getError` which has the exact same structure with an empty body.
#' @details
#' See endpoints available with `endpoints()`
#' @keywords internal

get_gen <- function(endpoint, query = NULL, limit = 100, flatten = TRUE, verbose = TRUE,...) {

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
      if (verbose){
          message(sprintf("API request failed (%s): %s", httr::status_code(resp),
             httr::content(resp)$message))
      }
      responses[[page + 1]] <- structure(list(body = NULL, response = resp), class = "getError")
    } else {
      responses[[page + 1]] <- structure(list(
        body = resp_raw(resp),
        response = resp), class = "getSuccess")
    }
  }
  # check error here if desired;
  out <- list(
    body = unlist(purrr::map(responses, "body"), recursive = FALSE),
    response = unlist(purrr::map(responses, "body"), recursive = FALSE)
  )
  class(out) <- "mgGetResponses"
  out
}


#' Generic API function to retrieve singletons
#'
#' @param endpoint `character` API entry point
#' @param ids `numeric` vector of ids
#' @param output `character` output type (`data.frame`, `list`, `spatial`, `raw`) return; default: `list`
#' @param flatten `logical` return flatten nested data.frame, see [jsonlite::flatten()]; default: `TRUE`
#' @param verbose `logical` print API code status on error; default: `TRUE`
#' @param ... httr options, see [httr::GET()]
#' @return
#' Object of class `mgGetResponses` whithin each level is the specific ID called.
#' Each item of the `mgGetResponses` list corresponds to an API call. Each call returns an object:
#' - `getSuccess` which is a list with the body [httr::content()] and the server response [httr::response()].
#' - `getError` which has the exact same structure with an empty body.
#' @details
#' See endpoints available with `endpoints()`
#' @keywords internal
# get_singletons(endpoint = endpoints()$network, ids = c(1101, 1102), flatten = FALSE)
get_singletons <- function(endpoint = NULL, ids = NULL, verbose = FALSE,
   ...) {

  stopifnot(!is.null(endpoint) & !is.null(ids))
  # Prep output object
  responses <- list(body = list(), response = list())
  errors <- NULL
  class(responses) <- "mgGetResponses"

  # Loop over ids
  for (i in seq_along(ids)) {
    # Set url
    url <- httr::modify_url(server(), path = paste0(base(), endpoint, "/", ids[i]))

    # Call on the API
    resp <- httr::GET(url, config = httr::add_headers(`Content-type` = "application/json"),
      ua, ...)

    if (httr::http_error(resp)) {
      if (verbose) {
        message(sprintf("API request failed (%s): %s", httr::status_code(resp), httr::content(resp)$message))
      }
      errors <- append(errors, i)
    } else {
      # coerce body to output desired
      responses$body[[i]] <- resp_raw(resp)
      responses$response[[i]] <- resp
    }
  }
  if (!is.null(errors)) warning("Failed request(s) : ", paste0(errors, ", "))

  responses
}
