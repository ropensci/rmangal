#' Query nodes
#'
#' Search for networks by querying the nodes table.
#' If the `query` is a character string, then all character columns in the table
#' are searched and the entries for which at least one
#' partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a specific column (see Details section)
#'
#' @param query either a character string including a single keyword or a named list containing a custom query (see details section below).
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [httr::GET()].
#'
#' @details
#' Names of the list should match one of the column names within the table. 
#' For the `networks` table, those are:
#' * id: unique identifier of the nodes;
#' * original_name: taxonomic name as in the original publication;
#' * node_level: either population, taxon or individual;
#' * network_id: Mangal network identifier.
#'
#' Note that for lists with more than one element, only the first element is used, the others are ignored. An example is provided below.
#'
#' @seealso
#' [search_taxonomy()]
#'
#' @return
#' An object of class `mgSearchNodes`, which basically is a `data.frame` object 
#' including taxa that are matching the query and corresponding information.
#' All networks in which taxa are involved are also attached to the `data.frame`.
#'
#' @references
#' * <https://mangal.io/#/>
#' * <https://mangal-interactions.github.io/mangal-api/#nodes>
#'
#' @examples
#' \donttest{
#'  res_acer <- search_nodes("Acer")
#'  res_926 <- search_nodes(list(network_id = 926))
#' }
#' @export

search_nodes <- function(query, verbose = TRUE, ...) {

  query <- handle_query(query, c("original_name", "node_level", "network_id"))

  nodes <- resp_to_df_flt(get_gen(endpoints()$node, query = query,
      verbose = verbose, ...)$body)
  if (all(dim(nodes) == 1)) 
    return(data.frame())

  nodes <- nodes[, names(nodes)[names(nodes) != "taxonomy"]]

  class(nodes) <- append(class(nodes), "mgSearchNodes")
  nodes

}
