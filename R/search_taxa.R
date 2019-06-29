#' Search network by taxa using keyword or specific taxonomic identifiers.
#'
#' @param query either a character string including a single keyword or a list containing a custom query (see details section below).
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param tsn a `numeric`. Unique taxonomic identifier from Integrated Taxonomic Information System (<https://www.itis.gov/>).
#' @param gbif a `numeric`. Unique taxonomic identifier from Global Biodiversity Information Facility (<https://www.gbif.org/>).
#' @param eol a `numeric`. Unique taxonomic identifier from Encyclopedia of Life (<https://eol.org/>).
#' @param col a `numeric`. Unique taxonomic identifier from Catalogue of Life (<https://www.catalogueoflife.org/>).
#' @param bold a `numeric`. Unique taxonomic identifier from Barcode of Life (<http://www.boldsystems.org/>).
#' @param ncbi a `numeric`. Unique taxonomic identifier from National Center for Biotechnology Information (<https://www.ncbi.nlm.nih.gov/>).
#' @param original a `logical`. Should query taxa names from the original publication? (see details section, default is set to `FALSE`, only work for full text search)
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [httr::GET()]
#'
#' @details
#' By default, the user query the `taxonomy` table and the based a homogenized taxonomy (valid names from
#' [TNRS](http://tnrs.iplantcollaborative.org/) and/or [GNR](https://resolver.globalnames.org/).
#' These taxa might not be the taxon name documented in the original publication.
#' In order to query, the original name, set argument `original` to `TRUE`.
#'
#' Note that the validation of taxon names was performed by an automated
#' procedure and if there is any doubt, the original names recorded
#' by authors should be regarded as the most reliable information. Please
#' report any issue related to taxonomy at <https://github.com/mangal-wg/mangal-datasets/issues>.
#'
#' @return
#' An object of class `mgSearchTaxa`, which is a `data.frame` object with all taxa matching the query.
#' All networks in which taxa are involved are also attached to the `data.frame`.
#'
#' @references
#' <https://mangal-wg.github.io/mangal-api/#nodes>
#' <https://mangal-wg.github.io/mangal-api/#taxonomy>
#'
#' @examples
#' search_taxa("Acer")
#' # Retrieve higher classification
#' tsn_acer <- search_taxa("Acer")$taxonomy.tsn
#' search_taxa(list(network_id = 926), original = TRUE)
#' @export

search_taxa <- function(query, tsn = NULL, gbif = NULL, eol = NULL,
  col = NULL, bold = NULL, ncbi = NULL, original = FALSE, verbose = TRUE, ...) {

  # prep query
  req <- unlist(
    list(tsn = tsn, gbif = gbif, eol = eol, col = col, bold = bold, ncbi = ncbi)
  )

  if (length(req)) {
      if (length(req) > 1) {
        stop("Query with multiple criteria not allowed.")
      } else query <- req
  } else {
    if (original) {
      query <- handle_query(query, c("original_name", "node_level", "network_id"))
    } else query <- handle_query(query, c("name", "rank"))
  }

  if (original) {
    nodes <- resp_to_df_flt(get_gen(endpoints()$node, query = query,
      verbose = verbose, ...)$body)
      # Store network ids
    # Store network ids
    network_ids <- nodes$network_id
  } else {

    taxa <- resp_to_df(get_gen(endpoints()$taxonomy, query = query,
      verbose = verbose, ...)$body)

    if (length(taxa)) {
      nodes <- do.call(rbind, lapply(taxa$id, function(x)
        get_from_fkey_flt(endpoints()$node, taxonomy_id = x,
          verbose = verbose, ...)))
      # Store network ids
      network_ids <- nodes$network_id
    } else network_ids <- NULL
  }

  # Retrieve network in which taxa are involved
  if (length(network_ids)) {
    nodes$networks <- resp_to_spatial(get_singletons(endpoints()$network,
      network_ids, verbose = verbose, ...)$body)
  } else nodes <- data.frame()

  # do not work with original = TRUE, so skipped.
  # if (verbose)
  #   message(sprintf("Found %s taxa involved in %s network(s)",
  #     nrow(taxa), length(network_ids)))

  class(nodes) <- append(class(nodes), "mgSearchTaxa")
  nodes

}
