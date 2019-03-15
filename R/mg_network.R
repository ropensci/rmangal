#' Retrieve full network (edges and nodes)
#'
#' @param id `numeric` mangal ID network
#' @return 
#' object `mgNetwork: 
#' - network: `list` of all generic informations on the network
#' - nodes: `data.frame` of all nodes with taxonomic informations
#' - edges: `data.frame` of all edges (ecological interactions), with the attribute used to describe the interaction
#' @examples
#' mg_network(id = 18)
#' @export


mg_network <- function(id = NULL, ... ) {

    stopifnot(!is.null(id))
    
    mg_network <- structure(list(network = get_singletons(endpoints()$network, ids = id)[[1L]]$body, nodes = NULL, edges = NULL),
        class = "mgNetwork")

    mg_network$nodes <- as.data.frame(get_gen(endpoints()$node, query = list( network_id = mg_network$network$id )))
    mg_network$edges <- as.data.frame(get_gen(endpoints()$interaction, query = list( network_id = mg_network$network$id )))

    return(mg_network)

}
