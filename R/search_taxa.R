#' Search network by taxa using keyword, tsn, eol, bold or ncbi IDs.
#'
#' @param query `character` query on taxa names
#' @param tsn a `numeric`. Unique taxonomic identifier from Integrated Taxonomic Information Sytem (https://www.itis.gov/)
#' @param gbif a `numeric`. Unique taxonomic identifier from Global Biodiversity Information Facility (https://www.gbif.org/)
#' @param eol a `numeric`. Unique taxonomic identifier from Encyclopedia of Life (https://eol.org/)
#' @param col a `numeric`. Unique taxonomic identifier from Catalogue of Life (https://www.catalogueoflife.org/)
#' @param bold a `numeric`. Unique taxonomic identifier from Barcode of Life (http://www.boldsystems.org/)
#' @param ncbi a `numeric`. Unique taxonomic identifier from National Center for Biotechnology Information (https://www.ncbi.nlm.nih.gov/)
#' @param original a `logical`. Should query taxa names from the original publication? (see details section, default is set to `FALSE`, only work for full text search)
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

search_taxa <- function(query = NULL, tsn = NULL, gbif = NULL, eol = NULL,
  col = NULL, bold = NULL, ncbi = NULL, original = FALSE, verbose = TRUE, ...) {

  # prep query
  request <- list(q = query, tsn = tsn, gbif = gbif, eol = eol, col = col,
    bold = bold, ncbi = ncbi)

  if (sum(!sapply(request, is.null)) > 1) {
    stop("Query with multiple criteria not allowed")
  } else if (sum(!sapply(request, is.null)) == 0) {
    stop("Query unspecified")
  }

  if (is.character(query) & verbose) message("Full text search")

  if (!is.null(query) & original) {

    taxa <- resp_to_df0(get_gen(endpoints()$node, query = request)$body)
    # Store network ids
    network_ids <- taxa$network_id

  } else {

    taxa <- resp_to_df0(get_gen(endpoints()$taxonomy, query = request)$body)

    if (length(taxa)) {
      tmp_nodes <- do.call(rbind, lapply(taxa$id, function(x)
        get_from_fkey_flt(endpoints()$node, taxonomy_id = x)))

      # Add original publication name for the taxa
      taxa$original_name <- tmp_nodes$original_name
      # Store network ids
      network_ids <- tmp_nodes$network_id
    } else network_ids <- NULL

  }

  # Retrieve network in which taxa are involved
  if (length(network_ids)) {
    taxa$networks <- resp_to_spatial0(get_singletons_tmp(endpoints()$network, network_ids)$body)
  } else {
    taxa <- data.frame(NULL)
  }

  if (verbose)
    message(sprintf("Found %s taxa involved in %s network(s)", nrow(taxa), length(network_ids)))

  class(taxa) <- append(class(taxa), "mgSearchTaxa")
  taxa

}


  # if (!original) {
  #
  #   taxa <- resp_to_df0(get_gen(endpoints()$taxonomy, query = list(q = query))$body)
  #
  #   if (length(taxa)) {
  #     tmp_nodes <- do.call(rbind, lapply(taxa$id, function(x)
  #       get_from_fkey_flt(endpoints()$node, taxonomy_id = x)))
  #
  #     # Add original publication name for the taxa
  #     taxa$original_name <- tmp_nodes$original_name
  #     # Retrieve network in which taxa are involved
  #     network_ids <- tmp_nodes$network_id
  #   } else network_ids <- NULL
  #
  # } else {
  #
  #   taxa <- resp_to_df0(get_gen(endpoints()$node,
  #     query = list(q = query))$body)
  #   network_ids <- taxa$network_id
  #
  # }
