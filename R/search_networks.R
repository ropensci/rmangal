#' Query networks
#'
#' Search over all networks using a keyword, a custom query or a spatial object
#' If the `query` is a character string, then all character columns in the table
#' are searched and the entries for which at least one
#' partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a specific column (see Details section)
#'
#' @param query either a character string including a single keyword or a list containing a custom query (see details section below), or a spatial object (see the description of `query_sf`).
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param query_sf a spatial object of class `sf` used to search in a specific geographical area.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [httr::GET()].
#'
#' @return
#' An object of class `mgSearchNetworks`, which is a `data.frame` object with all networks informations
#'
#' @details
#' Names of the list should match one of the column names within the table.
#' For the `networks` table, those are
#' - id: unique identifier of the network
#' - all_interactions: false interaction can be considered as real false interaction
#' - dataset_id: the identifier of the dataset
#' - public: network publicly available
#'
#' Note that for lists with more than one element, only the first element is used, the others are ignored. An example is provided below.
#'
#' @references
#' Metadata available at <https://mangal-wg.github.io/mangal-api/#networks>
#'
#' @examples
#' mg_insect <- search_networks(query="insect%")
#' \donttest{
#' # Retrieve the search results
#' nets_insect <- get_collection(mg_insect)
#' # Spatial query
#' library(USAboundaries)
#' area <- us_states(state="california")
#' networks_in_area <- search_networks(area, verbose = FALSE)
#' plot(networks_in_area)
#' }
#' # Retrieve network ID 5013
#' net_5013 <- search_networks(query = list(id = 5013))
#' # Network(s) of dataset ID 19
#' mg_19 <- search_networks(list(dataset_id = 19))
#'
#' @export

search_networks <- function(query, verbose = TRUE, ...) {

  query <- handle_query(query, c("id", "public", "all_interactions", "dataset_id"))

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

#' @describeIn search_networks Search networks within a spatial object passed as an argument. Note that `sf` must be installed to use this function.
#' @export
search_networks_sf <- function(query_sf, verbose = TRUE, ...) {

  stopifnot("sf" %in% class(query_sf))
  stop_if_missing_sf()

  # API doesn't allow spatial search yet, so we used sf
  sp_networks_all <- resp_to_spatial(
      get_gen(endpoints()$network, verbose = verbose, ...)$body,
      as_sf = TRUE)
  # sf_networks_all to WGS 84 / World Mercator, a planar CRS
  id <- unlist(sf::st_contains(
        sf::st_transform(query_sf, crs = 3395),
        sf::st_transform(sp_networks_all, crs = 3395)))
  class(sp_networks_all) <- append(class(sp_networks_all), "mgSearchNetworks")
  sp_networks_all[id, ]
}
