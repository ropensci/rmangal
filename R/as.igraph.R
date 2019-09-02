#' Coerce `mgNetworksCollection` or `mgNetwork` objects to `igraph` objects.
#'
#' @param x either a `mgNetworksCollection` or a `mgNetwork` object.
#' @param ... currently ignored.
#'
#' @return
#' An object of class `igraph` for a `mgNetwork` object and a list of
#' `igraph` objects for `mgNetworksCollection`.
#'
#' @importFrom igraph as.igraph
#' @describeIn as.igraph Convert `mgNetwork` objects to `igraph` objects.
#' @export 
as.igraph.mgNetwork <- function(x, ...) {
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


#' @describeIn as.igraph Convert `mgNetworksCollection` objects to a list of `igraph` objects.
#' @export
as.igraph.mgNetworksCollection <- function(x, ...) {
    lapply(x, as.igraph.mgNetwork)
}

#' @export
igraph::as.igraph
