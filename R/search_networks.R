#' Search over all networks using keyword or spatial object
#'
#' @param query `character` keyword used to search over all networks (case sensitive) or a `sf` object
#' used to search in a specific geographical area. If keyword is unspecified (query = NULL), all networks will be returned.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @return
#' An object of class `mgSearchNetworks`, which is a `data.frame` object with all networks informations
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

search_networks <- function(query = NULL, verbose = TRUE, ...) {

  if ("sf" %in% class(query)) {

    polygon <- query

    if (verbose) message("Spatial query mode")
    # API doesn't allow spatial search - patch with R
    sp_networks <- resp_to_spatial(get_gen(endpoints()$network, ...)$body)
    if (is.null(sp_networks)) {
      if (verbose) message("No network found!")
      return(data.frame())
    }
    # Set projection to WGS84
    networks <- sp_networks[unlist(
      sf::st_contains(sf::st_transform(polygon, crs = 4326), sp_networks)),]

  } else {

    # Full search
    if (is.character(query)) query <- list( q = query )

    networks <- resp_to_spatial(get_gen(endpoints()$network, query = query,
     ...)$body)
    if (is.null(networks)) {
      if (verbose) message("no network found")
      return(data.frame())
    }

  }

  if (verbose) message(sprintf("Found %s networks", nrow(networks)))

  class(networks) <- append(class(networks), "mgSearchNetworks")
  networks
}
