#' Query interactions
#'
#' Search for specific interactions using a keyword or a specific type of
#' interactions (e.g. mutualism). If the `query` is a character string, then
#' all character columns in the table are searched and the entries for which at
#' least one partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a
#' specific column (see Details).
#'
#' @inheritParams search_datasets
#' @param type a `character` one of the interactions type available (see
#' details). Note that `query` is ignored if `type` is used.
#' @param expand_node a logical. Should the function returned extra information
#' pertaining to nodes? Default is set to `FALSE`, which means that only the
#' Mangal IDs of nodes are returned.
#'
#' @return
#' An object of class `mgSearchInteractions`, i.e. a `data.frame` object
#' including interactions.
#' All networks in which interactions are involved are also attached to the
#' `data.frame`.
#'
#' @details
#' Names of the list should match one of the column names within the table.
#' For the `interaction` table, those are:
#' * `id`: unique identifier of the interaction;
#' * `attr_id`: identifier of a specific attribute;
#' * `direction`: edge direction ("directed", "undirected" or "unknown");
#' * `network_id`: Mangal network identifier;
#' * `node_from`: node id which the interaction originates;
#' * `node_to`: node to which the interaction goes;
#' * `type`: use argument `type` instead.
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
#' @references
#' * <https://mangal.io/#/>
#' * <https://mangal-interactions.github.io/mangal-api/#taxonomy>
#'
#' @examples
#' \donttest{
#' df_inter <- search_interactions(type = "competition")
#' # Get all networks containing competition
#' competition_networks <- get_collection(df_inter)
#' df_net_926 <- search_interactions(list(network_id = 926))
#' }
#' @export

search_interactions <- function(query, type = NULL, expand_node = FALSE, ...) {
  if (!is.null(type)) {
    rmangal_inform("`type` used, `query` ignored.")
    type <- match.arg(type, avail_type())
    query <- list(type = type)
  } else {
    query <- handle_query(
      query,
      c("id", "attr_id", "direction", "network_id", "node_from", "node_to", "type")
    )
  }

  # Get interactions based on the type
  interactions <- rmangal_request(
    endpoint = "interaction", query = query, ...
  )$body |>
    resp_to_df()

  if (is.null(interactions)) {
    rmangal_inform("No interactions found.")
    return(data.frame())
  }

  # Add extra info about nodes if desired
  if (expand_node) {
    tmp <- lapply(interactions$node_from, function(id) {
      rmangal_request_singleton("node", id = id)$body
    }) |> resp_to_df_flt()
    interactions[, paste0("node_from_", names(tmp))] <- tmp
    #
    tmp <- lapply(interactions$node_to, function(id) {
      rmangal_request_singleton("node", id = id)$body
    }) |> resp_to_df_flt()
    interactions[, paste0("node_to_", names(tmp))] <- tmp
  }

  rmangal_inform("Found {nrow(interactions)} interaction{?s}")

  class(interactions) <- append(class(interactions), "mgSearchInteractions")
  interactions
}

#' List interactions type contained in mangal-db
avail_type <- function() {
  c(
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
}
