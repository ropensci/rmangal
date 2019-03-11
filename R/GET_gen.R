#' GET generic function
#'
#' @param endpoint `character` API entry point
#' @param query `list` list of params passed to the API
#' @param limit `integer` number of entries return by the API (max: 1000)
#' @param flatten `logical` flatten nested data.frame, see [jsonlite::flatten()]
#' @param output `character` output type: `data.frame`, `list`, `json`
#' @param token  `character` Access bearer token (mandatory)
#' @param ... httr options, see [httr::GET()]
#' @return
#' Object of class `getSuccess` or `getError`.
#' `getSuccess` is a list with the body [httr::content()] and the server response [httr::response()]. 
#' `getError` has the exact same structure with the body empty.
#' @details
#' See endpoints available with `print(endpoints)`
#' @examples
#' @export

get_gen <- function(endpoint = NULL, query = NULL, limit =100, flatten = TRUE, output = 'data.frame', token = bearer(), ...) {

  stopifnot(exists("endpoint") | is.null(endpoint))

  url <- httr::modify_url(server(), path = paste0(base(), endpoint))

  # Remove NA for querying
  if(!is.null(query)) query[which(is.na(query) | query == "NA")] <- NULL

  # Get number of pages
  resp <- httr::GET(url, config = httr::add_headers(`Content-type` = "application/json",
    Authorization = paste("Bearer", token)),ua, query = query, ...)
  
  # Prep output object
  responses <- list()
  class(responses) <- "mangalGetResp"

  # Cover status is 401
  if(httr::status_code(resp) == 401){
    stop(httr::content(resp)$message)
  }

  # Get number of page
  rg <- as.numeric(stringr::str_extract_all(httr::headers(resp)["content-range"],
    simplify=TRUE,
    "\\(?[0-9,.]+\\)?"))

  # Prep iterator over pages
  if (rg[3] < limit) {
    pages <- 0
  } else {
    pages <- ceiling(rg[3] / limit) - 1
  }

  # Loop over pages
  for (page in 0:pages) {
    query$page <- page

    resp <- httr::GET(url, config = httr::add_headers(`Content-type` = "application/json",
      Authorization = paste("Bearer", token)), ua, query = query, ...)

    # prep output
    if(output == 'json'){
      body <- httr::content(resp, type = "text", encoding = "UTF-8")
    } else if(output == 'list') {
      body <- httr::content(resp)
    } else if(output == 'data.frame') {
      body <- tibble::as_tibble(jsonlite::fromJSON(httr::content(resp, type = "text", encoding = "UTF-8"), flatten = TRUE, simplifyDataFrame = TRUE))
    } else if(output == 'sf') { 
        body <- tibble::as_tibble(jsonlite::fromJSON(httr::content(resp, type = "text", encoding = "UTF-8"), flatten = TRUE, simplifyDataFrame = TRUE))
        stopifnot(all(c("localisation.type", "localisation.coordinates") %in% names(body)))
        features <- apply(body, 1, function(feature){
              return(list(type="Feature", geometry=list(type=feature$localisation.type,coordinates=feature$localisation.coordinates)))
            })
        
        body <- dplyr::select(body, -c(localisation.type, localisation.coordinates))

        # get sf geom
        geom_s <- sf::read_sf(
          jsonlite::toJSON(
            list(
              type="FeatureCollection",
              features=features),
              auto_unbox=TRUE
          )
        )

        body <- sf::st_sf(dplyr::bind_cols(body,geom_s), sf_column_name = "geometry")
    }

    if (httr::http_error(resp)) {
      message(sprintf("API request failed: [%s]\n%s", httr::status_code(resp),
        body$message), call. = FALSE)

      responses[[page + 1]] <- structure(list(body = NULL, response = resp),
          class = "getError")

    } else {

      responses[[page + 1]] <- structure(list(body = body, response = resp),
        class = "getSuccess")

    }

  }

  return(responses)

}
