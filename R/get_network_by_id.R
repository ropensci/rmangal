#' Retrieve mangal network by id 
#'
#' @param id `numeric` mangal ID network
#' @param ... arguments from [rmangal::get_singletons()]
#' @return
#' a `mgNetwork` object which include:
#' - network: `list` of all generic informations on the network
#' - nodes: `data.frame` of all nodes with taxonomic informations
#' - edges: `data.frame` of all edges (ecological interactions), with the attribute used to describe the interaction
#' - dataset: `list` of all informations on the dataset associated to the network
#' - reference: `list` of all informations on the original publication
#' @examples
#' get_network_by_id(id = 18)
#' @export


get_network_by_id <- function(id, ... ) {

    stopifnot(length(id) == 1)

    # Object S3 declaration
    mg_network <- structure(
      list(
        network = get_singletons(endpoints()$network, ids = id)[[1L]]$body
      ),
      class = "mgNetwork"
    )

    if(is.null(mg_network$network)) stop(sprintf("No found network id %s", id))

    # nodes and edges associated with the network
    mg_network$nodes <- as.data.frame(get_from_fkey(endpoints()$node, 
                  network_id = mg_network$network$id))
    mg_network$edges <- as.data.frame(get_from_fkey(endpoints()$interaction, 
                  network_id = mg_network$network$id))

    # retrieve dataset informations
    mg_network$dataset <- as.data.frame(get_singletons(endpoints()$dataset, ids = unique(mg_network$network$dataset_id)))

    # retrieve reference
    mg_network$reference <- as.data.frame(get_singletons(endpoints()$reference, ids = unique(mg_network$dataset$ref_id)))

    mg_network
}
