#' Coerce `mgNetworksCollection` or `mgNetwork` objects to `igraph` objects
#'
#' @param x `mgNetworksCollection` or `mgNetwork` objects.
#'
#' @return
#' An object of class `igraph`
#'
#' @examples
#' insects_networks <- get_collection(search_networks(query='insect%'))
#' # Apply as.igraph on one specific network
#' insects_network <- insects_networks[[1]]
#' ig_network <- as.igraph(insects_network)
#' # Apply as.igraph on networks collection
#' ig_coll_networks <- as.igraph(insects_networks)
#' # Plot igraph object with vertex label
#' plot(ig_network, vertex.label = insects_network$nodes$taxonomy.name)
#'
#' @export
as.igraph <- function(x) {
    UseMethod("as.igraph", x)
}

#' @describeIn as.igraph Coerce `mgNetworksCollection` to `igraph` object.
#' @export
as.igraph.mgNetworksCollection <- function(x) {
    lapply(x, as.igraph.mgNetwork)
}

#' @describeIn as.igraph Coerce `mgNetwork` to `igraph` object.
#' @export
as.igraph.mgNetwork <- function(x) {
    # Simple test to know if the graph is directed or undirected
    directed <- ifelse(unique(x$edges$direction) == "directed", TRUE, FALSE)

    # Move id edge to the last column
    x$edges <- as.data.frame(x$edges)
    # print(x$edges)
    # drop geometry
    x$edges <- x$edges[,names(x$edges) != "geom"]
    x$edges <- x$edges[, c(2:ncol(x$edges), 1)]

    igraph::graph_from_data_frame(d = x$edges[, 1:17], directed = directed,
      vertices = x$nodes)
}
