#' Retrieve full network (edges and nodes)
#'
#' @param name `character` API entry point
#' @param description `list` list of params passed to the API
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
#' See endpoints available with `print(endpoints)`
#' @examples
#' @export

# get_gen <- function(endpoint = NULL, query = NULL, limit =100, flatten = TRUE, output = 'data.frame', ...) {
