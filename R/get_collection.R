#' Get a collection of networks
#'
#' @param x `numeric` vector of mangal network IDs or an object returned by
#' by on of the `search_*()` functions.
#' @param ... arguments to be passed on to [rmangal::get_network_by_id()].
#' @return
#'  If there is only one network to be retrieved, `get_collection()` returns a
#' `mgNetwork` object, otherwise it returns a object of class
#' `mgNetworksCollection` which is a collection (a list) of `mgNetwork`
#' objects [rmangal::get_network_by_id()]).
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
  get_network_by_id(x)
}

#' @describeIn get_collection Get a collection of networks from a `mgSearchDatasets` object.
#' @export
get_collection.mgSearchDatasets <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(unlist(purrr::map(x$networks, "id")))
  get_network_by_id(net_ids)
}

#' @describeIn get_collection Get a collection of networks from a `mgSearchNetworks` object.
#' @export
get_collection.mgSearchNetworks <- function(x, ...) {
  # Get networks ids
  get_network_by_id(x$id)
}


#' @describeIn get_collection Get a collection of networks from a `mgSearchReference` object.
#' @export
get_collection.mgSearchReference <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(x$networks$id)
  get_network_by_id(net_ids)
}


#' @describeIn get_collection Get a collection of networks from a `mgSearchTaxa` object.
#' @export
get_collection.mgSearchTaxa <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(x$networks$id)
  get_network_by_id(net_ids)
}


#' @describeIn get_collection Get a collection of networks from a `mgSearchTaxa` object.
#' @export
get_collection.mgSearchInteractions <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(x$network_id)
  get_network_by_id(net_ids)
}
