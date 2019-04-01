#' Search network by taxa using keyword, tsn, eol, bold or ncbi IDs.
#'
#' @param query `character` specific taxon / keyword / or tsn, eol, bold & ncbi IDs.
#' @param original a `logical`. Should query taxa names from the original publication? (see details section, default: FALSE) 
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @details
#' By default, you are querying taxa based on a homogenized taxonomy (corrected names from
#' [TNRS](http://tnrs.iplantcollaborative.org/) and/or [GNR](https://resolver.globalnames.org/). 
#' These taxa might not be the taxa recorded within the original publication. 
#' To query original documented taxa, please set the argument `original` as TRUE.
#' @return
#' An object of class `mgSearchTaxonomy`, which is a `data.frame` object with all taxa matching the query. 
#' All networks in which taxa are involved are also attached to the `data.frame`.
#' @examples
#' search_taxa("Acer")
#' @export

search_taxa <- function( query = NULL, original = FALSE, verbose = TRUE, ... ) {

    stopifnot(!is.null(query) & is.character(query))

    if ( original == FALSE ) {

        taxa <- as.data.frame(get_gen(endpoints()$taxonomy, query = list(q = query)))
        tmp_nodes <- sapply(taxa$id ,function(x) get_from_fkey(endpoints()$node, taxonomy_id = x ))
        tmp_nodes <- do.call(rbind,purrr::map(tmp_nodes, "body"))

        # Add original publication name for the taxa
        taxa$original_name <- tmp_nodes$original_name
        
        # Retrieve network in which taxa are involved
        network_ids <- tmp_nodes$network_id
        taxa$networks <- as.data.frame(get_singletons(endpoints()$network, network_ids))

    } else {

        taxa <- as.data.frame(get_gen(endpoints()$node, query = list(q = query)))
        network_ids <- taxa$network_id
        taxa$networks <- as.data.frame(get_singletons(endpoints()$network, network_ids))

    }

    if (verbose) message(sprintf("Found %s taxa", nrow(taxa)))

    class(taxa) <- append(class(taxa), "mgSearchTaxa")
    taxa

}
