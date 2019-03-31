#' Search network by taxa using keyword, tsn, eol, bold or ncbi IDs.
#'
#' @param query `character` specific taxon / keyword / or tsn, eol, bold & ncbi IDs.
#' @param original a `logical`. Should query taxa from the original publication? (see details section) 
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @details
#' By default, you are querying taxa based on a homogenized taxonomy across all datasets using
#' TNRS (http://tnrs.iplantcollaborative.org/) and/or GNR (https://resolver.globalnames.org/). 
#' Be aware that these taxa might not be the taxa from the original publication. 
#' To query original documented taxa, please set the argument `original` as TRUE.
#' @return
#' An object of class `mgSearchTaxonomy`, which is a `data.frame` object with all taxa matching the query. 
#' All networks in which taxa are involved are also attached to the `data.frame`.
#' @export

search_taxa <- function( query = NULL ) {

    stopifnot(!is.null(query) & is.character(query))



}
