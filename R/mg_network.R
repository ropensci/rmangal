#' Retrieve full network (edges and nodes)
#'
#' @param id `character` API entry point
#' @param ... httr options, see [httr::GET()]
#' @return
#' @details
#' @examples
#' @export


mg_network <- function(id = NULL, ... ) {

    stopifnot(!is.null(id))
    
    mg_network <- structure(list(network = get_singletons(endpoints()$network, ids = id)[[1L]]$body, nodes = NULL, edges = NULL),
        class = "mgNetwork")

    mg_network$nodes <- as.data.frame(get_gen(endpoints()$node, query = list( network_id = mg_network$network$id )))
    mg_network$edges <- as.data.frame(get_gen(endpoints()$interaction, query = list( network_id = mg_network$network$id )))

    return(mg_network)

}
