#' Query taxonomy
#'
#' Search network by taxon names and unique taxonomic identifiers.
#' This function offers the opportunity to retrieve taxon based on (i) known identifier 
#' such as the taxonomic serial number (TSN), GBIF ID etc. or (ii) text search using partial match. 
#' Have a look at the list of arguments to see the complete list of identifiers accessible.
#' If any unique identifier argument is used (i.e. tsn etc.), then `query` is ignored. Moreover,
#' if several taxonomic identifiers are specified, then only the first one is considered.
#'
#' @param query a character string including a single keyword.
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param tsn a `numeric`. Unique taxonomic identifier from Integrated Taxonomic Information System (<https://www.itis.gov>).
#' @param gbif a `numeric`. Unique taxonomic identifier from Global Biodiversity Information Facility (<https://www.gbif.org>).
#' @param eol a `numeric`. Unique taxonomic identifier from Encyclopedia of Life (<https://eol.org>).
#' @param col a `numeric`. Unique taxonomic identifier from Catalogue of Life (<https://www.catalogueoflife.org>).
#' @param bold a `numeric`. Unique taxonomic identifier from Barcode of Life (<http://www.boldsystems.org>).
#' @param ncbi a `numeric`. Unique taxonomic identifier from National Center for Biotechnology Information (<https://www.ncbi.nlm.nih.gov>).
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [httr::GET()].
#'
#' @details
#' Taxon names of the `taxonomy` table were validated with
#' TNRS (see <https://tnrs.biendata.org> and/or GNR
# ' (see <https://resolver.globalnames.org/>). The taxon names in this table
#' might not be the taxon name documented in the original publication.
#' In order to identify relevant networks with the original name, use
#' [search_nodes()].
#'
#' The validation of taxon names was performed by an automated
#' procedure and if there is any doubt, the original names recorded
#' by authors should be regarded as the most reliable information. Please
#' report any issue related to taxonomy at <https://github.com/mangal-interactions/contribute/issues/new/choose/>.
#'
#' @return
#' An object of class `mgSearchTaxonomy`, which is a `data.frame` including
#' all taxa matching the query.
#'
#' @references
#' * <https://mangal.io/#/>
#' * <https://mangal-interactions.github.io/mangal-api/#taxonomy>
#'
#' @seealso
#' [search_nodes()]
#'
#' @examples
#' \donttest{
#'  search_taxonomy("Acer")
#'  # Retrieve higher classification
#'  tsn_acer <- search_taxonomy("Acer")$taxonomy.tsn
#' }
#' @export

search_taxonomy <- function(query, tsn = NULL, gbif = NULL, eol = NULL,
  col = NULL, bold = NULL, ncbi = NULL, verbose = TRUE, ...) {

  # prep query
  req <- Filter(Negate(is.null),
    list(tsn = tsn, gbif = gbif, eol = eol, col = col, bold = bold, ncbi = ncbi)
  )

  if (length(req)) {
      if (length(req) > 1) {
        stop("Queries with multiple criteria are not allowed.")
      } else query <- req
  } else {
    stopifnot(is.character(query))
    query <- list(q = query)
  }

  taxa <- resp_to_df(get_gen(endpoints()$taxonomy, query = query,
      verbose = verbose, ...)$body)

  if (length(taxa)) {
      # retrieve corresponding nodes
      nodes <- do.call(rbind, lapply(taxa$id, function(x)
        get_from_fkey_flt(endpoints()$node, taxonomy_id = x,
          verbose = verbose, ...)))
      # Store network ids
      network_ids <- nodes$network_id
    } else {
      if (verbose) message("No taxon found.")
      return(data.frame())
    }

  if (verbose)
    message(sprintf("Found %s taxa involved in %s network(s)",
      nrow(taxa), nrow(network_ids)))

  class(nodes) <- append(class(nodes), "mgSearchTaxonomy")
  nodes

}
