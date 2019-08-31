#' Coerce `mgNetworksCollection` or `mgNetwork` objects to `igraph` objects.
#'
#' @param x either a `mgNetworksCollection` or a `mgNetwork` object.
#' @param ... currently ignored.
#'
#' @return
#' An object of class `igraph` for a `mgNetwork` object and a list of
#' `igraph` objects for `mgNetworksCollection`.
#'
#' @examples
#' lagoon_networks <- get_collection(search_networks(query='lagoon%'), verbose = FALSE)
#' # Apply mg_to_igraph on one specific network
#' lagoon_network <- lagoon_networks[[1]]
#' ig_network <- mg_to_igraph(lagoon_network)
#' # Apply mg_to_igraph on networks collection
#' ig_coll_networks <- mg_to_igraph(lagoon_networks)
#' # Plot igraph object with vertex label
#' plot(ig_network, vertex.label = lagoon_network$nodes$taxonomy.name)
#' @export

mg_to_igraph <- function(x, ...) {
    UseMethod("mg_to_igraph", x)
}


#' @describeIn mg_to_igraph Convert`mgNetwork` objects to `igraph` objects.
#' @export
mg_to_igraph.mgNetwork <- function(x, ...) {
    # Simple test to know if the graph is directed or undirected
    directed <- ifelse(all(x$interactions$direction == "directed"), TRUE, FALSE)
    # Move id edge to the last column
    x$interactions <- as.data.frame(x$interactions, stringsAsFactors = FALSE)
    # drop geometry
    x$interactions <- x$interactions[, names(x$interactions) != "geom"]
    nm <- c("node_from", "node_to")
    x$interactions <- x$interactions[, c(nm, names(x$interactions)[! names(x$interactions) %in% nm])]
    igraph::graph_from_data_frame(d = x$interactions, directed = directed,
      vertices = x$nodes)
}


#' @describeIn  mg_to_igraph Convert `mgNetworksCollection` objects to `igraph` objects.
#' @export
mg_to_igraph.mgNetworksCollection <- function(x, ...) {
    lapply(x, mg_to_igraph.mgNetwork)
}
