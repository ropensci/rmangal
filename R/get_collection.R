#' Get a collection of networks
#'
#' @param x `numeric` vector of mangal network IDs or object return by functions `search_*`.
#' @param ... arguments to be passed on to [rmangal::get_network_by_id()].
#' @return
#' object `mgNetworksCollection`:
#' - collection of networks: `list` of object `mgNetwork` (see [rmangal::get_network_by_id()])
#' @examples
#' \dontrun{
#' get_collection(c(1035:1036))
#' get_collection(search_networks(query='insect%'))
#' get_collection(search_datasets(query='lagoon%'))
#' }
#' @export

get_collection <- function(x, ...) {
  UseMethod("get_collection", x)
}

#' @describeIn get_collection Get a collection of networks (default).
#' @export
get_collection.default <- function(x, ...) {

  mg_net_collection <- structure(list(), class= "mgNetworksCollection")

  for (i in seq_len(length(x))) {
    mg_net_collection[[i]] <- get_network_by_id(x[i], ...)
  }

  mg_net_collection

}

#' @describeIn get_collection Get a collection of networks from a `mgSearchDatasets` object.
#' @export
get_collection.mgSearchDatasets <- function(x, ...) {

  # Object S3 declaration
  mg_net_collection <- structure(list(), class= "mgNetworksCollection")

  # Get networks ids
  net_ids <- unique(unlist(purrr::map(x$networks,"id")))

  for (i in seq_len(length(net_ids))) {
    mg_net_collection[[i]] <- get_network_by_id(net_ids[i], ...)
  }

  mg_net_collection

}

#' @describeIn get_collection Get a collection of networks from a `mgSearchNetworks` object. 
#' @export
get_collection.mgSearchNetworks <- function(x, ...) {

  # Object S3 declaration
  mg_net_collection <- structure(list(), class= "mgNetworksCollection")

  for (i in seq_len(length(x$id))) {
    mg_net_collection[[i]] <- get_network_by_id(x$id[i])
  }

  mg_net_collection

}


#' @describeIn get_collection Get a collection of networks from a `mgSearchReference` object. 
#' @export
get_collection.mgSearchReference <- function(x, ...) {

  # Object S3 declaration
  mg_net_collection <- structure(list(), class= "mgNetworksCollection")

  for (i in seq_len(length(x$networks$id))) {
    mg_net_collection[[i]] <- get_network_by_id(x$networks$id[i])
  }

  mg_net_collection

}


#' @describeIn get_collection Get a collection of networks from a `mgSearchTaxa` object. 
#' @export
get_collection.mgSearchTaxa <- function(x, ...) {

  uq_ids <- unique(x$networks$id)

  # Object S3 declaration
  mg_net_collection <- structure(list(), class= "mgNetworksCollection")

  for (i in seq_len(length(uq_ids))) {
    mg_net_collection[[i]] <- get_network_by_id(uq_ids[i])
  }

  mg_net_collection

}
