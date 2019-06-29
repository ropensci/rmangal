#' Search over all networks using keyword or spatial object
#'
#' @param query either a character string including a single keyword or a list containing a custom query (see details section below), or a spatial object (see the description of `query_sf`).
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param query_sf a spatial object of class `sf` used to search in a specific geographical area. If keyword is unspecified (query = NULL), all networks will be returned.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#'
#' @return
#' An object of class `mgSearchNetworks`, which is a `data.frame` object with all networks informations
#' @details
#' If `query` is a character string, then all fields of the database table
#' including character strings are searched and entries for which at least one
#' partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a specific field.
#' In this case, the name of the list should match one of the field names of the database table.
#' For the `networks` table, those are:
# - attr_id: identifier of a specific attribute
# - direction: edge direction ("directed", "undirected" or "unknown")
# - network_id: Mangal network identifier
# - node_from: node id which the interaction end to
# - node_to: node to which the interaction end to
# - type: use argument `type` instead.
#' Note that for lists with more than one element, only the first element is used, the others are ignored. An example is provided below.
#'
#' @references
#' <https://mangal-wg.github.io/mangal-api/#networks>
#'
#' @examples
#' search_networks(query="insect%")
#' \donttest{
#' # Spatial query
#' library(USAboundaries)
#' area <- us_states(state="california")
#' networks_in_area <- search_networks(area)
#' plot(networks_in_area)
#' }
#' @export

search_networks <- function(query, verbose = TRUE, ...) {

  if ("sf" %in% class(query))
    return(search_networks_sf(query, verbose, ...))
  query <- handle_query(query, c("public", "all_inteactions", "dataset_id"))

  networks <- resp_to_spatial(get_gen(endpoints()$network, query = query,
    verbose = verbose, ...)$body)
  if (is.null(networks)) {
    if (verbose)
      message("No network found.")
    return(data.frame())
  }

  if (verbose)
    message(sprintf("Found %s networks", nrow(networks)))

  class(networks) <- append(class(networks), "mgSearchNetworks")
  networks
}

#' @describeIn search_networks Search network within a spatial object passed as an argument.
search_networks_sf <- function(query_sf, verbose = TRUE, ...) {
  stopifnot("sf" %in% class(query_sf))
  # API doesn't allow spatial search yet so we sort with sf
  sp_networks_all <- resp_to_spatial(
      get_gen(endpoints()$network, verbose = verbose, ...)$body)
  # Set to WGS 84 / World Mercator
  id <- unlist(sf::st_contains(
        sf::st_transform(query_sf, crs = 3395),
        sf::st_transform(sp_networks_all, crs = 3395)))
  class(sp_networks_all) <- append(class(sp_networks_all), "mgSearchNetworks")
  sp_networks_all[id, ]
}
