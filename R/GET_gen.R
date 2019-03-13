#' GET generic function
#'
#' @param endpoint `character` API entry point
#' @param query `list` list of params passed to the API
#' @param limit `integer` number of entries return by the API (max: 1000)
#' @param flatten `logical` flatten nested data.frame, see [jsonlite::flatten()]
#' @param output `character` output type: `data.frame`, `list`, `json`
#' @param ... httr options, see [httr::GET()]
#' @return
#' Object of class `getSuccess` or `getError`.
#' `getSuccess` is a list with the body [httr::content()] and the server response [httr::response()]. 
#' `getError` has the exact same structure with the body empty.
#' @details
#' See endpoints available with `print(endpoints)`
#' @examples
#' @export

get_gen <- function(endpoint = NULL, query = NULL, limit =100, flatten = TRUE, output = 'data.frame', ...) {

  stopifnot(exists("endpoint") | is.null(endpoint))

  url <- httr::modify_url(server(), path = paste0(base(), endpoint))

  # First call used to set pages
  resp <- httr::GET(url, config = httr::add_headers(`Content-type` = "application/json"),ua, query = query, ...)
  
  # Prep output object
  responses <- list()
  class(responses) <- "mangalGet"

  # Cover status is 401
  if(httr::status_code(resp) == 401){
    stop(httr::content(resp)$message)
  }

  # Get number of page
  rg <- as.numeric(stringr::str_extract_all(httr::headers(resp)["content-range"],
    simplify=TRUE,
    "\\(?[0-9,.]+\\)?"))

  # Prep iterator over pages
  pages <- ifelse(rg[3] < limit, 0, floor(rg[3] / limit))

  # Loop over pages
  for (page in 0:pages) {
    query$page <- page

    resp <- httr::GET(url, config = httr::add_headers(`Content-type` = "application/json"), ua, query = query, ...)

    # prep output
    if(output == 'json'){
      body <- httr::content(resp, type = "text", encoding = "UTF-8")
    } else if(output == 'list') {
      body <- httr::content(resp)
    } else if(output == 'data.frame') {
      body <- tibble::as_tibble(jsonlite::fromJSON(httr::content(resp, type = "text", encoding = "UTF-8"), flatten = flatten))
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
