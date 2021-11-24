#' Query interactions
#'
#' Search for specific interactions using a keyword or a specific type of
#' interactions (e.g. mutualism). If the `query` is a character string, then all character columns in the table
#' are searched and the entries for which at least one
#' partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a specific column (see Details section)
#'
#' @param query either a character string including a single keyword or a named list containing a custom query (see details section below).
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param type a `character` one of the interactions type available (see details). Note that `query` is ignored if `type` is used.
#' @param expand_node a logical. Should the function returned extra information pertaining to nodes? Default is set to `FALSE`, which means that only the Mangal IDs of nodes are returned.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [httr::GET()].
#'
#' @return
#' An object of class `mgSearchInteractions`, i.e. a `data.frame` object including interactions.
#' All networks in which interactions are involved are also attached to the `data.frame`.
#'
#' @details
#' Names of the list should match one of the column names within the table.
#' For the `interaction` table, those are:
#' * id: unique identifier of the interaction;
#' * attr_id: identifier of a specific attribute;
#' * direction: edge direction ("directed", "undirected" or "unknown");
#' * network_id: Mangal network identifier;
#' * node_from: node id which the interaction end to;
#' * node_to: node to which the interaction end to;
#' * type: use argument `type` instead.
#'
#' Note that for lists with more than one element, only the first element is
#' used, the others are ignored. The type of interactions (argument `type`)  
#' currently available are the following
#' * "competition";
#' * "amensalism";
#' * "neutralism";
#' * "commensalism";
#' * "mutualism";
#' * "parasitism";
#' * "predation";
#' * "herbivory";
#' * "symbiosis";
#' * "scavenger";
#' * "detritivore".
#'
#'
#' @references
#' * <https://mangal.io/#/>
#' * <https://mangal-interactions.github.io/mangal-api/#taxonomy>
#'
#' @examples
#' \donttest{
#'  df_inter <- search_interactions(type = "competition", verbose = FALSE)
#'  # Get all networks containing competition
#'  competition_networks <- get_collection(df_inter, verbose = FALSE)
#'  df_net_926 <- search_interactions(list(network_id = 926), verbose = FALSE)
#' }
#' @export

search_interactions <- function(query, type = NULL, expand_node = FALSE,
  verbose = TRUE, ...) {

    if (!is.null(type)) {
      if (verbose) message("`type` used, `query` ignored.")
      type <- match.arg(type, avail_type())
      query <- list(type = type)
    } else {
      query <- handle_query(query,
        c("id" ,"attr_id", "direction", "network_id", "node_from", "node_to", "type"))
    }

    # Get interactions based on the type
    interactions <- resp_to_spatial(get_gen(endpoints()$interaction,
      query = query, verbose = verbose, ...)$body, keep_geom = FALSE)

    if (is.null(interactions)) {
      if (verbose) message("No interactions found.")
      return(data.frame())
    }

    # Add extra info about nodes if desired
    if (expand_node) {
      tmp <- resp_to_df_flt(get_singletons(endpoints()$node,
        interactions$node_from, verbose = verbose, ...)$body)
      interactions[, paste0("node_from_", names(tmp))] <- tmp
      #
      tmp <- resp_to_df_flt(get_singletons(endpoints()$node,
        interactions$node_to, verbose = verbose, ...)$body)
      interactions[, paste0("node_to_", names(tmp))] <- tmp
    }

    if (verbose) message(sprintf("Found %s interactions", nrow(interactions)))

    class(interactions) <- append(class(interactions), "mgSearchInteractions")
    interactions

}

#' List interactions type contains in mangal-db
avail_type <- function() c(
  "competition",
  "amensalism",
  "neutralism",
  "commensalism",
  "mutualism",
  "parasitism",
  "predation",
  "herbivory",
  "symbiosis",
  "scavenger",
  "detritivore",
  "unspecified"
)
