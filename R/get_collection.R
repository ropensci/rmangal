#' Retrieve mangal networks collection
#'
#' @param ids `numeric` vector of mangal network IDs or object `mangalSearch` returned by functions `search_*`
#' @param ... arguments from [rmangal::get_network_by_id()]
#' @return
# object `mgNetworksCollection`: 
#' - networks: `list` of object `mgNetwork` (see [rmangal::get_network_by_id()])
#' @examples
#' get_collection(ids = c(1035:1037))
#' @export

get_collection <- function(ids , ... ) {

  # Object S3 declaration
  mg_networks_collection <- structure(
    list(
      networks = list() # list of mgNetwork class
    ),
    class = "mgNetworksCollection"
  )
  
  for(i in seq_len(length(ids))){
    mg_networks_collection$networks[[i]] <- get_network_by_id(ids[i], ...)
  }

  mg_networks_collection

}
