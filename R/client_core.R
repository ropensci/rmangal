#' Core utilities
#'
#' @keywords internal
#'
#' @noRd

rmangal_api_url <- function(base = "https://mangal.io/api", version = "v2") {
  paste(base, version, sep = "/") |>
    httr2::request()
}


rmangal_request <- function(endpoint = "", query = NULL, limit = 100, ...) {
  if (is.character(query)) query <- list(q = query)

  req <- rmangal_api_url() |>
    httr2::req_url_path_append(rmangal_endpoint_path(endpoint)) |>
    httr2::req_user_agent("rmangal") |>
    httr2::req_url_query(!!!c(query, count = limit)) |>
    httr2::req_headers("Content-type" = "application/json") |>
    # httr2::req_cache(tempdir()) |>
    # httr2::req_throttle()  |>
    httr2::req_error(is_error = \(resp) FALSE)

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


rmangal_request_singleton <- function(endpoint = "", id, ...) {
  stopifnot(length(id) == 1)
  req <- rmangal_api_url() |>
    httr2::req_url_path_append(rmangal_endpoint_path(endpoint)) |>
    httr2::req_url_path_append(id) |>
    httr2::req_user_agent("rmangal") |>
    httr2::req_headers("Content-type" = "application/json") |>
    # httr2::req_cache(tempdir()) |>
    httr2::req_error(is_error = \(resp) FALSE)

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

rmangal_endpoint_path <- function(endpoint) {
  if (!endpoint %in% rmangal::rmangal_endpoints$name) {
    cli::cli_abort(
      "Unknown endpoint, see the list of endpoints in 
      `rmangal::rmangal_endpoints()`"
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