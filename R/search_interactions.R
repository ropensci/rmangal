#' Search for specific interactions type (e.g. mutualism)
#'
#' @param type a `character` one of the interactions type available in the function `avail_type()`
#' @param expand_node a `logical`. Should the function returned more information on nodes
#' involved in the interaction? Default is set to `FALSE`, which means that only the mangal ID of nodes are returned.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @return
#' An object of class `mgSearchInteractions`, which is a `data.frame` object with all interaction matching the interaction type provided.
#' All networks in which interactions are involved are also attached to the `data.frame`.
#' @examples
#' search_interactions("competition")
#' # Get all networks containing competition
#' competition_networks <- get_collection(search_interactions("competition"))
#' @export

search_interactions <- function( type = avail_type(), expand_node = FALSE, verbose = FALSE ) {

    # Make sure args match options
    type <- match.arg(type)
    # Get interactions based on the type
    interactions <- resp_to_spatial(get_gen(endpoints()$interaction,
      query = list( type = type ))$body)

    if (is.null(interactions)) {
      if (verbose) message("No interactions found")
      return(data.frame())
    }

    # Expand content on node
    if (expand_node ) {
      tmp <- resp_to_df(get_singletons(endpoints()$node,
        interactions$node_from)$body)
      interactions[, paste0("node_from_", names(tmp))] <- tmp
      #
      tmp <- resp_to_df(get_singletons(endpoints()$node,
        interactions$node_to)$body)
      interactions[, paste0("node_to_", names(tmp))] <- tmp
    }

    # Get networks
    interactions$networks <- resp_to_spatial(
      get_singletons(endpoints()$network, interactions$network_id)$body)

    if (verbose) message(sprintf("Found %s interactions", nrow(interactions)))

    class(interactions) <- append(class(interactions), "mgSearchInteractions")
    interactions

}

#' List interactions type contains in mangal-db
#' @export
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
