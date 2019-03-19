#' Search mangal networks
#'
#' @param query `character` keyword used to search (case sensitive).
#' @param polygon `sf` object used to search in a specific geographical area.
#' @param ... arguments from [rmangal::get_gen()], ignored for spatial query
#' @return
#' object `data.frame`: Networks.
#' @examples
#' search_networks(query="insect%")
#' # Spatial exemple
#' @export

search_networks <- function( query = NULL, polygon = NULL, ... ) {

  if(!is.null(polygon)){

    message("Spatial query mode")
    
    # API doesn't allow spatial search - patch with R 
    sp_networks <- as.data.frame(get_gen(endpoints()$network, output = "spatial"))
    
    # Making sure polygon is sf class
    stopifnot("sf" %in% class(polygon))
    # Making sure projection are WGS84
    stopifnot(sf::st_crs(polygon)$epsg == "4326")

    networks <- sf::st_intersection(sp_networks, polygon)

  } else {

    # Full search
    if(is.character(query)){
      query <- list( q = query )
    }

    networks <- as.data.frame(get_gen(endpoints()$network, query = query,  ...))

  }

  class(networks) <- append(class(networks),"mgSearchNetworks")
  networks
}
