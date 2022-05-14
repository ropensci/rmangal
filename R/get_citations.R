#' Retrieve all references pertaining to the networks collection or individual network
#'
#' @param x an object of class `mgNetworksCollection` or `mgNetworks`.
#'
#' @return
#' Bibtex entries as a character vector.
#'
#' @examples
#' \donttest{
#'  # network collection
#'  lagoon_net_collection <- get_collection(search_datasets("lagoon"))
#'  get_citation(lagoon_net_collection)
#'  # individual network
#'  mg_18 <- get_network_by_id(18)
#'  get_citation(mg_18)
#' }
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
    unique(unlist(lapply(x, function(y) get_citation(y))))
}
