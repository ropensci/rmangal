#' Retrieve mangal network including the nodes and the edges
#'
#' @param id `numeric` mangal ID network
#' @param ... arguments from [rmangal::get_singletons()]
#' @return
#' object `mgNetwork`: 
#' - network: `list` of all generic informations on the network
#' - nodes: `data.frame` of all nodes with taxonomic informations
#' - edges: `data.frame` of all edges (ecological interactions), with the attribute used to describe the interaction
#' - dataset: `list` of all informations on the dataset associated to the network
#' - reference: `list` of all informations on the original publication
#' @examples
#' get_network_by_id(id = 18)
#' @export


get_network_by_id <- function(id, ... ) {

    # Object S3 declaration
    mg_network <- structure(
      list(
        network = get_singletons(endpoints()$network, ids = id)[[1L]]$body
      ),
      class = "mgNetwork"
    )

    # nodes and edges associated with the network
    mg_network$nodes <- as.data.frame(get_gen(endpoints()$node,
      query = list( network_id = mg_network$network$id )))
    mg_network$edges <- as.data.frame(get_gen(endpoints()$interaction,
      query = list( network_id = mg_network$network$id )))

    # retrieve DATASET informations
    dataset <- get_singletons(endpoints()$dataset, ids = unique(mg_network$network$dataset_id))

    # Assign dataset informations to mg_network
    mg_network$dataset <- purrr::flatten(purrr::map(dataset,"body"))

    # retrieve REFERENCE 
    reference <- get_singletons(endpoints()$reference, ids = mg_network$dataset$ref_id)

    # Assign dataset informations to mg_network
    mg_network$reference <- purrr::flatten(purrr::map(reference,"body"))

    mg_network
}
