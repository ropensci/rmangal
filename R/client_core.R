#' Core utilities
#'
#' @keywords internal
#'
#' @noRd

rmangal_api_url <- function(base = "https://mangal.io/api", version = "v2") {
    paste(base, version, sep = "/") |>
        httr2::request()
}


rmangal_request <- function(endpoint = "", query = NULL, limit = 100, verbose = TRUE, ...) {
    req <- rmangal_api_url() |>
        httr2::req_url_path_append(rmangal_endpoint_path(endpoint)) |>
        httr2::req_user_agent("rmangal") |>
        httr2::req_url_query(q = query, count = limit) |>
        # httr2::req_cache(tempdir()) |>
        httr2::req_headers("Content-type" = "application/json") |>
        # httr2::req_throttle()  |>
        httr2::req_error(is_error = \(resp) FALSE)

    resp <- do_request(req)
    if (is.null(resp)) {
        if (verbose) {
            cli::cli_inform("Empty response.")
        }
        return(NULL)
    }

    resps <- httr2::req_perform_iterative(
        req, 
        httr2::iterate_with_offset(
            "page",
            start = 0,
        resp_pages = \(resp) {
            pag  <- resp |>
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
 
    # check error here if desired;
    structure(list(
        body = resps |>
            lapply(httr2::resp_body_json) |>
            do.call(what = c),
        response = resps
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
            "Unknown enpoint, see the list of endpoint rmangal::rmangal_endpoints"
        )
    }
    rmangal::rmangal_endpoints$path[rmangal::rmangal_endpoints$name == endpoint]
}