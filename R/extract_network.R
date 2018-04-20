#' @title extract_network
#'
#' @description Visualize the interactions of a network
#' 
#' @return an igraph object
#'
#' @param id The id of a network


extract_network <- function(id){
  
  taxa <- extract_obj(id, "taxa", "vector", "id", "network_id")
  interaction <- extract_obj(taxa, "interaction", "dataframe", filter = c("taxon_1", "taxon_2", "value"), c("taxon_1", "taxon_2"))

  # faire matrice d'adjacence
  matAdj <- igraph::graph.data.frame(interaction, directed=FALSE)
  
  # illuster le reseau
  matAdj <- igraph::get.adjacency(matAdj)
  matAdj <- igraph::graph.adjacency(matAdj) 
  
  #return(matAdj)
  plot(matAdj, edge.arrow.mode = 0, vertex.label = NA)
}
