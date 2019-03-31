#' Search over all networks using keyword or spatial object
#'
#' @param query `character` keyword used to search (case sensitive) or a `sf` object used to search in a specific geographical area.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @return
#' An object of class `mgSearchNetworks`, which is a `data.frame` object with all networks informations
#' @examples
#' search_networks(query="insect%")
#' \dontrun{
#' # Spatial query
#' library(USAboundaries)
#' area <- us_states(state="california")
#' networks_in_area <- search_networks(area)
#' plot(networks_in_area)
#' }
#' @export

search_networks <- function(query = NULL, verbose = TRUE) {

  if ("sf" %in% class(query)) {

    polygon <- query

    if (verbose) message("Spatial query mode")
    # API doesn't allow spatial search - patch with R
    sp_networks <- as.data.frame(get_gen(
      endpoints()$network, output = "spatial"))

    # Making sure projection are WGS84
    networks <- sp_networks[unlist(
      sf::st_contains(sf::st_transform(polygon, crs = 4326), sp_networks)),]

  } else {

    # Full search
    if (is.character(query)) {
      query <- list( q = query )
    }
    
    networks <- as.data.frame(get_gen(endpoints()$network, query = query))

  }

  if (verbose) message(sprintf("Found %s networks", nrow(networks)))

  class(networks) <- append(class(networks), "mgSearchNetworks")
  networks
}
