#' Search network by taxa using keyword, tsn, eol, bold or ncbi IDs.
#'
#' @param query `character` query on taxa names
#' @param original a `logical`. Should query taxa names from the original publication? (see details section, default is set to `FALSE`)
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @details
#' By default, you are querying taxa based on a homogenized taxonomy (corrected names from
#' [TNRS](http://tnrs.iplantcollaborative.org/) and/or [GNR](https://resolver.globalnames.org/).
#' These taxa might not be the taxon name used in the original publication.
#' In order to query, the original name, set argument `original` to `TRUE`.
#' @return
#' An object of class `mgSearchTaxa`, which is a `data.frame` object with all taxa matching the query.
#' All networks in which taxa are involved are also attached to the `data.frame`.
#' @examples
#' search_taxa("Acer")
#' # Retrieve higher classification
#' tsn_acer <- search_taxa("Acer")$tsn
#' taxize::classification(tsn_acer, db = "itis")
#' @export

search_taxa <- function( query = NULL, tsn = NULL, gbif = NULL, eol = NULL, col =  NULL, bold = NULL, ncbi = NULL, original = FALSE, verbose = TRUE, ... ) {
    
    # prep query
    request <- list(
      q = query,
      tsn = tsn,
      gbif = gbif, 
      eol = eol, 
      col =  col, 
      bold = bold, 
      ncbi = ncbi
    )

    if (sum(!sapply(request,is.null)) > 1) {
      stop("Query multiple criteria not allowed")
    } else if (sum(!sapply(request,is.null)) == 0) {
      stop("Query unspecified")
    }

    if(is.character(query)){
      if(verbose) message("Full text search")
    } 

    if (!is.null(query) & original) {

      taxa <- as.data.frame(get_gen(endpoints()$node, query = request))
      network_ids <- taxa$network_id

    } else {

      taxa <- as.data.frame(get_gen(endpoints()$taxonomy, query = request))

      if (length(taxa)) {
        tmp_nodes <- do.call(rbind,
            purrr::map(sapply(taxa$id,
              function(x) get_from_fkey(endpoints()$node, taxonomy_id = x )), "body"))

        # Add original publication name for the taxa
        taxa$original_name <- tmp_nodes$original_name
        # Retrieve network in which taxa are involved
        network_ids <- tmp_nodes$network_id
      } else network_ids <- NULL

    }

    if (length(network_ids)) {
      taxa$networks <- as.data.frame(get_singletons(endpoints()$network, network_ids))
    } else {
      taxa <- data.frame(NULL)
    }


    if (verbose) message(sprintf("Found %s taxa involved in %s network(s)", nrow(taxa), length(network_ids)))

    class(taxa) <- append(class(taxa), "mgSearchTaxa")
    taxa

}
