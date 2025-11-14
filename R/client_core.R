#' Low-level request function for the Mangal API
#'
#' These functions send a request to a specified endpoint of the Mangal API.
#'
#' @param endpoint A character string specifying the API endpoint to query.
#'   Must be one of the endpoints listed in [rmangal_endpoints()].
#' @param query Either a character string for a keyword search, or a named list
#'   for custom queries. If `NULL`, all records are returned.
#' @param limit An integer specifying the maximum number of results per page.
#'   Default is 100.
#' @param cache Logical or character. If `TRUE`, results are cached in a
#' temporary directory. If a character string, it specifies the cache 
#' directory. If `FALSE` (default), no caching is used. See [httr2::req_cache()]
#' for further details about caching in this context.
#' @param ... Additional arguments (currently ignored).
#'
#' @return An object of class `mgGetResponses` containing the response body
#'   and the raw HTTP response(s).
#' 
#' @describeIn rmangal_request Send a request to a specified endpoint of the 
#' Mangal API and returns all matching results.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Search for networks with keyword "insect"
#' result <- rmangal_request("network", query = "insect", limit = 10)
#'
#' # Custom query for a specific dataset
#' result <- rmangal_request("network", query = list(dataset_id = 19))
#' }
rmangal_request <- function(endpoint, query = NULL, limit = 100, cache = FALSE, ...) {
  if (is.character(query)) query <- list(q = query)

  req <- rmangal_api_url() |>
    httr2::req_url_path_append(rmangal_endpoint_path(endpoint)) |>
    httr2::req_user_agent("rmangal") |>
    httr2::req_url_query(!!!c(query, count = limit)) |>
    httr2::req_headers("Content-type" = "application/json") |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    cache_request(cache)


  resp <- do_request(req)
  if (is.null(resp)) {
    rmangal_inform("Empty response.")
    return(NULL)
  }

  resps <- httr2::req_perform_iterative(
    req,
    httr2::iterate_with_offset(
      "page",
      start = 0,
      resp_pages = \(resp) {
        pag <- resp |>
          httr2::resp_headers("Content-Range") |>
          as.character() |>
          strsplit(split = "\\D+") |>
          unlist() |>
          as.numeric() |>
          Filter(f = Negate(is.na))
        (pag[3] %/% limit) + 1
      }
    ),
    on_error = "return"
  )

  structure(list(
    body = resps |>
      lapply(httr2::resp_body_json) |>
      do.call(what = c),
    response = resps
  ), class = "mgGetResponses")
}


#' @describeIn rmangal_request Retrieves a single resource by its ID from a 
#' specified endpoint of the Mangal API.
#'
#' @param id An integer or character specifying the unique identifier of the
#'   resource to retrieve. Must be a single value.
#' @param ... Additional arguments (currently ignored).
#'
#' @return An object of class `mgGetResponses` containing the response body
#'   and the raw HTTP response.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Retrieve network with ID 5013
#' result <- rmangal_request_singleton("network", id = 5013)
#' }
rmangal_request_singleton <- function(endpoint, id, cache = FALSE, ...) {
  stopifnot(length(id) == 1)
  req <- rmangal_api_url() |>
    httr2::req_url_path_append(rmangal_endpoint_path(endpoint)) |>
    httr2::req_url_path_append(id) |>
    httr2::req_user_agent("rmangal") |>
    httr2::req_headers("Content-type" = "application/json") |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    cache_request(cache)

  resp <- do_request(req)
  if (is.null(resp)) {
    rmangal_inform("Empty response.")
    return(NULL)
  }

  structure(list(
    body = resp |> httr2::resp_body_json() |> list(),
    response = resp
  ), class = "mgGetResponses")
}


do_request <- function(req) {
  resp <- tryCatch(httr2::req_perform(req), error = function(e) e)
  if (inherits(resp, "httr2_failure")) {
    cli::cli_alert_danger(
      "{resp$message} Check your internet connection."
    )
    print(resp$trace)
    return(NULL)
  }
  if (httr2::resp_is_error(resp)) {
    cli::cli_alert_danger(
      "HTTP {resp |> httr2::resp_status()} {resp |> httr2::resp_status_desc()}."
    )
    return(NULL)
  }
  resp
}



rmangal_api_url <- function(base = "https://mangal.io/api", version = "v2") {
  paste(base, version, sep = "/") |>
    httr2::request()
}


rmangal_endpoint_path <- function(endpoint) {
  if (!endpoint %in% rmangal::rmangal_endpoints$name) {
    cli::cli_abort(
      "Unknown endpoint, see the list of endpoints in
      `rmangal::rmangal_endpoints`"
    )
  }
  rmangal::rmangal_endpoints$path[rmangal::rmangal_endpoints$name == endpoint]
}


handle_query <- function(query, names_available) {
  if (is.character(query)) {
    return(list(q = query))
  }
  if (!is.list(query)) {
    cli::cli_abort("`query` should either be a list or a character string.")
  }
  if (length(query) > 1) {
    cli::cli_warn("Only the first element of the list is considered.")
    query <- query[1L]
  }
  if (!names(query) %in% names_available) {
    cli::cli_abort(
      "Only {names_available} are valid names for custom queries."
    )
  }
  query
}


cache_request <- function(req, cache) {
  if (!isFALSE(cache)) {
    if (isTRUE(cache)) {
      req |> httr2::req_cache(tempdir())
    } else {
      req |> httr2::req_cache(cache)
    }
  } else {
    req
  }
}
