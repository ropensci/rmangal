#' Get a BibTeX entry for all publications in a given networks collection.
#'
#' @param x `mgNetworksCollection` or `mgNetworks` object class.
#' @return
#' Bibtex entries as a character vector.
#' @examples
#'  # network collection
#'  lagoon_net_collection <- get_collection(search_datasets("lagoon"))
#'  get_citation(lagoon_net_collection)
#'  # individual network
#'  network <- get_network_by_id(18)
#'  get_citation(network)
#' @export
get_citation <- function(x) {
  UseMethod("get_citation", x)
}

#' @describeIn get_citation Display the BibTeX of the network's publication
#' @export
get_citation.mgNetwork <- function(x) x$reference$bibtex

#' @describeIn get_citation Display the BibTeX of all publications part of the networks collection
#' @export
get_citation.mgNetworksCollection <- function(x) {
    unique(unlist(purrr::map(x, get_citation)))
}
