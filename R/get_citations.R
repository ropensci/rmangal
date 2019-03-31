#' Display all publications (BibTeX) involved in the networks collection
#'
#' @param collection `mgNetworksCollection` object class.
#' @return
#' `list` of bibtex for all references attached to the network collection
#' @examples
#' lagoon_datasets <- search_datasets("lagoon")
#' @export

get_citations <- function (collection){
    
    stopifnot("mgNetworksCollection" %in% class(collection))

    references <- purrr::map(collection$networks, "reference")
    unique(purrr::map_chr(references,"bibtex"))
}
