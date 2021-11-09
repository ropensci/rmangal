#' Get a collection of networks
#'
#' Retrieve a set of networks based on the results of one of the `search_*()`
#' function. The function also accepts a numeric vector of Mangal network IDs.
#'
#' @param x `numeric` vector of Mangal network IDs or an object returned by
#' by one of the `search_*()` functions.
#' @param ... arguments to be passed on to [rmangal::get_network_by_id()].
#'
#' @return
#'  Returns a object of class `mgNetworksCollection` which is a collection 
#' (actually, a list) of `mgNetwork` objects [rmangal::get_network_by_id()]).
#'
#' @seealso
#' [search_datasets()], [search_interactions()], [search_networks()],
#' [search_nodes()], [search_references()], [search_taxonomy()].
#'
#' @examples
#' \donttest{
#'  mg_2 <- get_collection(c(1076:1077), verbose = FALSE)
#'  mg_anemone <- get_collection(search_networks(query='anemone%'), verbose = FALSE)
#' }
#' @export

get_collection <- function(x, ...) {
  UseMethod("get_collection", x)
}

#' @describeIn get_collection Get a collection of networks (default).
#' @export
get_collection.default <- function(x, ...) {
  get_network_by_id(x, force_collection = TRUE, ...)
}

#' @describeIn get_collection Get a collection of networks from a `mgSearchDatasets` object.
#' @export
get_collection.mgSearchDatasets <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(unlist(purrr::map(x$networks, "id")))
  get_collection.default(net_ids, ...)
}

#' @describeIn get_collection Get a collection of networks from a `mgSearchNetworks` object.
#' @export
get_collection.mgSearchNetworks <- function(x, ...) {
  # Get networks ids
  get_collection.default(x$id, ...)
}


#' @describeIn get_collection Get a collection of networks from a `mgSearchReferences` object.
#' @export
get_collection.mgSearchReferences <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(unlist(purrr::map(x$networks, "id")))
  get_collection.default(net_ids, ...)
}

#' @describeIn get_collection Get a collection of networks from a `mgSearchNodes` object.
#' @export
get_collection.mgSearchNodes <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(x$network_id)
  get_collection.default(net_ids, ...)
}

#' @describeIn get_collection Get a collection of networks from a `mgSearchTaxa` object.
#' @export
get_collection.mgSearchTaxonomy <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(x$network_id)
  get_collection.default(net_ids, ...)
}


#' @describeIn get_collection Get a collection of networks from a `mgSearchTaxa` object.
#' @export
get_collection.mgSearchInteractions <- function(x, ...) {
  # Get networks ids
  net_ids <- unique(x$network_id)
  get_collection.default(net_ids, ...)
}
