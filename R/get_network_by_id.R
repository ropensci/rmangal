#' Retrieve mangal network by id
#'
#' @param ids a vector of mangal ID for networks (`numeric`).
#' @param id a single ID network (`numeric`).
#' @param verbose a logical. Should extra information be reported on progress?
#' @return
#' a `mgNetwork` object including:
#' - network: a `list` of all generic informations on the network;
#' - nodes: a `data.frame` of all nodes with taxonomic informations;
#' - edges: a `data.frame` of all edges (ecological interactions), with the attribute used to describe the interaction
#' - dataset: `list` information pertaining to the datasetthe network is associaated to;
#' - reference: `list` information about the original publication.
#' @examples
#' net18 <- get_network_by_id(id = 18)
#' nets <- get_network_by_id(id = c(18, 23))
#' @export

get_network_by_id <- function(ids, verbose = TRUE) {
    if (length(ids) > 1) {
      structure(
        lapply(ids, get_network_by_id_indiv, verbose),
        class= "mgNetworksCollection"
      )
    } else {
      get_network_by_id_indiv(ids, verbose)
    }
}


#' @describeIn get_network_by_id Retrieve a network by its  collection of networks (default).
#' @export
get_network_by_id_indiv <- function(id, verbose = TRUE) {
  stopifnot(length(id) == 1)
  # Object S3 declaration
  mg_network <- structure(list(network =
    resp_to_spatial(get_singletons(endpoints()$network,ids = id)$body)),
    class = "mgNetwork")

  if (is.null(mg_network$network))
    stop(sprintf("network id %s not found", id))

  # nodes and edges associated with the network
  mg_network$nodes <- get_from_fkey_flt(endpoints()$node,
    network_id = mg_network$network$id, verbose = verbose)
  mg_network$edges <- get_from_fkey_net(endpoints()$interaction,
    network_id = mg_network$network$id, verbose = verbose)

  # retrieve dataset informations
  mg_network$dataset <- resp_to_df(get_singletons(endpoints()$dataset,
    ids = unique(mg_network$network$dataset_id))$body)

  # retrieve reference
  mg_network$reference <- resp_to_df(get_singletons(endpoints()$reference,
    ids = unique(mg_network$dataset$ref_id))$body)

  mg_network
}
