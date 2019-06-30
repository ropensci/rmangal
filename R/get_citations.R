#' Get a BibTeX entry for every publication
#'
#' @param x an object of class `mgNetworksCollection` or `mgNetworks`.
#'
#' @return
#' Bibtex entries as a character vector.
#'
#' @examples
#'  # network collection
#'  lagoon_net_collection <- get_collection(search_datasets("lagoon"))
#'  get_citation(lagoon_net_collection)
#'  # individual network
#'  network <- get_network_by_id(18)
#'  get_citation(network)
#'
#' @export
get_citation <- function(x) {
  UseMethod("get_citation", x)
}

#' @describeIn get_citation Get BibTeX entries for the publication associated to the network.
#' @export
get_citation.mgNetwork <- function(x) x$reference$bibtex

#' @describeIn get_citation Get BibTeX entries for the publication associated to the networks.
#' @export
get_citation.mgNetworksCollection <- function(x) {
    unique(unlist(purrr::map(x, get_citation)))
}
