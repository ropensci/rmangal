#' Retrieve mangal networks collection
#'
#' @param ids `numeric` vector of mangal network IDs or object returned by functions `search_*`
#' @param ... arguments from [rmangal::get_network_by_id()]
#' @return
# object `mgNetworksCollection`: 
#' - networks: `list` of object `mgNetwork` (see [rmangal::get_network_by_id()])
#' @examples
#' get_collection(ids = c(1035:1037))
#' get_collection(search_networks(query="insect%"))
#' get_collection(search_datasets(query="lagoon%"))
#' @export

 get_collection <- function (x, ...) {
  UseMethod("get_collection", x)
 }

get_collection.numeric <- function(x, ... ) {
  
  mg_networks_collection <- structure(
    list(networks = list()), 
  class = "mgNetworksCollection")

  for(i in seq_len(length(x))){
    mg_networks_collection$networks[[i]] <- get_network_by_id(ids[i], ...)
  }

  mg_networks_collection

}

get_collection.mgSearchDatasets <- function(x, ... ) {
  
  # Object S3 declaration
  mg_networks_collection <- structure(
    list(networks = list()), 
  class = "mgNetworksCollection")

  ids <- purrr::flatten_int(purrr::map(x$networks,"id"))

  for(i in seq_len(nrow(x))){
    mg_networks_collection$networks[[i]] <- get_network_by_id(ids[i], ...)
  }

  mg_networks_collection

}

get_collection.mgSearchNetworks <- function(x, ... ) {
  
  # Object S3 declaration
  mg_networks_collection <- structure(
    list(networks = list()), 
  class = "mgNetworksCollection")

  for(i in seq_len(length(x$id))){
    mg_networks_collection$networks[[i]] <- get_network_by_id(x$id[i], ...)
  }

  mg_networks_collection

}
