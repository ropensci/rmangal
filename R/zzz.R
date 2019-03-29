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

# Spatial columns of mangal DB
sf_columns <- function(x) c("geom.type","geom.coordinates")

# Handle NULL to coerce into tibble
null_to_na <- function(x) {
    if (is.data.frame(x)) {
      # NULL already handle
      return(x)
    } else if( is.list(x)) {
      return(lapply(x, null_to_na)) 
    } else {
      return(ifelse(is.null(x), NA, x))
    }
}

#
coerce_body <- function(x, resp, flatten) {
  switch(
    x,
    raw = httr::content(resp, type = "text", encoding = "UTF-8"),
    list = httr::content(resp),
    data.frame = tibble::as_tibble(null_to_na(
      jsonlite::fromJSON(httr::content(resp, type = "text",
      encoding = "UTF-8"), flatten = flatten))),
    spatial = mg_to_sf(
     tibble::as_tibble(
       null_to_na(
       jsonlite::fromJSON(
         httr::content(resp, type = "text", encoding = "UTF-8"),
         flatten = TRUE)
       )
       )
     )
   )
}

#' GET generic API function to retrieve several entries
#'
#' @param endpoint `character` API entry point
#' @param query `list` list of params passed to the API
#' @param limit `integer` number of entries return by the API (max: 1000)
#' @param flatten `logical` flatten nested data.frame, see [jsonlite::flatten()]; default: `TRUE`
#' @param output `character` output type (`data.frame`, `list`, `spatial`, `raw`) return (default: data.frame)
#' @param ... httr options, see [httr::GET()]
#' @return
#' Object of class `mgGetResponses` whithin each level is a page.
#' Each item of the list `mgGetResponses` corresponds to an API call. Each call returns an object:
#' - `getSuccess` which is a list with the body [httr::content()] and the server response [httr::response()].
#' - `getError` which has the exact same structure with an empty body.
#' @details
#' See endpoints available with `endpoints()`

get_gen <- function(endpoint, query = NULL, limit =100, flatten = TRUE,
  output = 'data.frame', ...) {

  url <- httr::modify_url(server(), path = paste0(base(), endpoint))
  
  # First call used to set pages
  resp <- httr::GET(url,
      config = httr::add_headers(`Content-type` = "application/json"), ua,
      query = query, ...)
  
  # Prep output object
  responses <- list()
  class(responses) <- "mgGetResponses"

  # Get number of page
  tmp <- unlist(strsplit(httr::headers(resp)$"content-range", split = "\\D"))
  rg <- as.numeric(tmp[grepl("\\d", tmp)])

  # Prep iterator over pages
  pages <- ifelse(rg[3] < limit, 0, floor(rg[3] / limit))

  # Loop over pages
  for (page in 0:pages) {
    query$page <- page

    resp <- httr::GET(url,
      config = httr::add_headers(`Content-type` = "application/json"), ua,
      query = query, ...)

    if (httr::http_error(resp)) {
      message(sprintf("API request failed (%s): %s", httr::status_code(resp),
        httr::content(resp)$message))

      responses[[page + 1]] <- structure(list(body = NULL, response = resp),
          class = "getError")

    } else {

      # coerce body to output desired
      body <- coerce_body(output, resp, flatten)

      responses[[page + 1]] <- structure(list(body = body, response = resp),
        class = "getSuccess")

    }

  }

  responses

}

#' GET generic API function to retrieve singletons
#'
#' @param endpoint `character` API entry point
#' @param ids `numeric` vector of ids
#' @param output `character` output type (`data.frame`, `list`, `spatial`, `raw`) return; default: `list`
#' @param flatten `logical` flatten nested data.frame, see [jsonlite::flatten()]; default: `TRUE`
#' @param ... httr options, see [httr::GET()]
#' @return
#' Object of class `mgGetResponses` whithin each level is the specific ID called.
#' Each item of the `mgGetResponses` list corresponds to an API call. Each call returns an object:
#' - `getSuccess` which is a list with the body [httr::content()] and the server response [httr::response()].
#' - `getError` which has the exact same structure with an empty body.
#' @details
#' See endpoints available with `endpoints()`

get_singletons <- function(endpoint = NULL, ids = NULL, output = "list",
flatten = TRUE, ...) {

  stopifnot(!is.null(endpoint) & !is.null(ids))

  # Prep output object
  responses <- list()
  class(responses) <- "mgGetResponses"

  # Loop over ids
  for (i in seq_len(length(ids))) {
    # Set url
    url <- httr::modify_url(server(), path = paste0(base(), endpoint, "/",
      ids[i]))

    # Call on the API
    resp <- httr::GET(url,
      config = httr::add_headers(`Content-type` = "application/json"), ua,
      ...)

    if (httr::http_error(resp)) {
      message(sprintf("API request failed (%s): %s", httr::status_code(resp),
        httr::content(resp)$message))

      responses[[i]]  <- structure(list(body = NULL, response = resp),
          class = "getError")

    } else {

      # coerce body to output desired
      body <- coerce_body(output, resp, flatten)

      responses[[i]]  <- structure(list(body = body, response = resp),
        class = "getSuccess")

    }
  }

  responses

}

#' GET entries based on foreign key
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

get_from_fkey <- function(endpoint, ...) {
  query = list(...)
  get_gen(endpoint = endpoint, query = query)
}

#' Coerce body return by the API to an sf object
#'
#' @param body `data.frame` return by the API call
#' @return
#' sf object

mg_to_sf <- function(body) {

  if(all(!sf_columns() %in% names(body))){
    stop(sprintf("%s columns not in body columns [%s]\n",
      sf_columns(),names(body)))
  }

  # build individual feature
  features <- apply(body, 1, function(f){
    if(is.na(f$geom.type) | is.null(f$geom.coordinates)){
      return(NULL)
    } else {
      return(list(type="Feature", geometry=list(
        type=f$geom.type,coordinates=f$geom.coordinates)))
    }
  })

  # sf reads features collection
  geom_s <- sf::read_sf(
    jsonlite::toJSON(
      list(
        type = "FeatureCollection",
        features = features),
        auto_unbox = TRUE
    )
  )


  # remove spatial columns
  geom_df <- dplyr::select(body, -dplyr::one_of(sf_columns()))

  # bind spatial feature with attributes table
  geom_sdf <- sf::st_sf(dplyr::bind_cols(geom_df, geom_s))

  geom_sdf

}
