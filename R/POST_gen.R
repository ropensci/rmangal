#' POST generic function
#'
#' @param endpoint `character` API entry point
#' @param singleton `list` body send to the API
#' @param token `character` Access bearer token (mandatory)
#' @param verbose `logical` verbose mode TODO: implement within function
#' @param ... httr options, see [httr::GET()]
#' @return
#' TODO
#' @export

post_gen <- function(endpoint = NULL, singleton = NULL, token = bearer(), verbose = TRUE, ...) {

 stopifnot(is.null(endpoint))

  url <- httr::modify_url(server(), path = paste0(base(), endpoint))

  resp <- httr::POST(url, body = singleton,
    config = httr::add_headers(Authorization = paste("Bearer",
      token)), encode = "json", ua, verbose(), ...)

  if (resp$status != 201) {

    return(structure(list(body = httr::http_status(resp), response = resp), class = "postError"))

  } else if (resp$status == 201) {

    return(structure(list(body = jsonlite::fromJSON(httr::content(resp, "text")), response = resp), class = "postSuccess"))

  } 
}
