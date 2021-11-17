#' Retrieve network information, nodes, edges and references for a given set of Mangal network IDs
#'
#' @param ids a vector of Mangal ID for networks (`numeric`).
#' @param id a single ID network (`numeric`).
#' @param x an object of class `mgNetwork` or `mgNetworksCollection`.
#' @param object object of of class `mgNetwork` or `mgNetworksCollection`.
#' @param as_sf a logical. Should networks metadata be converted into an sf object? Note that to use this feature `sf` must be installed.
#' @param ... ignored.
#' @param force_collection a logical. Should the output to be of class  `mgNetworksCollection` even if it includes only one network.
#' @param verbose a logical. Should extra information be reported on progress?
#'
#' @rdname get_network_by_id
#'
#' @return
#' A `mgNetwork` object includes five data frames:
#' * network: includes all generic information on the network (if `as_sf=TRUE` then it is an object of class `sf`);
#' * nodes: information pertaining to nodes (includes taxonomic information);
#' * interactions: includes ecological interactions and their attributes;
#' * dataset: information pertaining to the original dataset;
#' * reference: details about the original publication.
#'
#' A summary method is available for objects of class `mgNetwork` object and returns the following network properties:
#' * the number of nodes;
#' * the number of edges;
#' * the connectance;
#' * the linkage density;
#' * the degree (in, out an total) and the eigenvector centrality of every nodes.
#'
#' @examples
#' \donttest{
#'  net18 <- get_network_by_id(id = 18)
#'  net18_c <- get_network_by_id(id = 18, force_collection = TRUE)  
#'  nets <- get_network_by_id(id = c(18, 23))
#' }
#' @export

get_network_by_id <- function(ids, as_sf = FALSE, force_collection = FALSE, 
  verbose = TRUE) {
    
    if (!length(ids)) {
      warning("length(ids) is 0, an empty dataframe is returned.")
      return(data.frame())
    } else {
      if (length(ids) == 1 & !force_collection) {
        get_network_by_id_indiv(ids, as_sf = as_sf, verbose = verbose)
      } else {
        structure(
          lapply(ids, get_network_by_id_indiv, as_sf = as_sf, verbose = verbose),
          class = "mgNetworksCollection"
        )
      }
    }
}


#' @describeIn get_network_by_id Retrieve a network by its  collection of networks (default).
#' @export
get_network_by_id_indiv <- function(id, as_sf = FALSE, verbose = TRUE) {

  id <- as.numeric(id)
  stopifnot(length(id) == 1 & !is.na(id))

  mg_network <- structure(list(network =
    resp_to_spatial(get_singletons(endpoints()$network, ids = id,
    verbose = verbose)$body, as_sf = as_sf)), class = "mgNetwork")

  if (is.null(mg_network$network))
    stop(sprintf("network id %s not found", id))

  # if (verbose) message("Retrieving nodes\n")
  mg_network$nodes <- get_from_fkey_flt(endpoints()$node,
    network_id = mg_network$network$id, verbose = verbose)
  # if (verbose) message("done!\nRetrieving interaction\n")
  mg_network$interactions <- get_from_fkey_flt(endpoints()$interaction,
    network_id = mg_network$network$id, verbose = verbose)
  # if (verbose) message("done")
  # retrieve dataset informations
  mg_network$dataset <- resp_to_df(get_singletons(endpoints()$dataset,
    ids = unique(mg_network$network$dataset_id, verbose = verbose))$body)

  # retrieve reference
  mg_network$reference <- resp_to_df(get_singletons(endpoints()$reference,
    ids = unique(mg_network$dataset$ref_id), verbose = verbose)$body)


  # Renames ids columns
  names(mg_network$network)[1] <- "network_id"
  names(mg_network$nodes)[1] <- "node_id"
  names(mg_network$interactions)[1] <- "interaction_id"
  names(mg_network$dataset)[1] <- "dataset_id"
  names(mg_network$reference)[1] <- "ref_id"

  mg_network
}

#' @rdname get_network_by_id
#' @method print mgNetwork
#' @export
print.mgNetwork <- function(x, ...) {
  cat(print_net_info(x$network$network_id, x$dataset$dataset_id, x$network$description,
        nrow(x$interactions), nrow(x$nodes)),
    print_taxo_ids(x$nodes), print_pub_info(x$reference), "\n\n", sep = "")
}

#' @rdname get_network_by_id
#' @method print mgNetworksCollection
#' @export
print.mgNetworksCollection <- function(x, ...) {
  cat("A collection of", length(x), "networks\n\n")
  nb <- min(length(x), 6)
  for (i in seq_len(nb)) print(x[[i]])
  if (length(x) > 6) cat(length(x) - 6, "network(s) not shown. \n\n")
}




#' Summarize mgNetwork properties
#'
#' Summarize mgNetwork properties.
#' @rdname get_network_by_id
#' @method summary mgNetwork
#' @export
summary.mgNetwork <- function(object, ...) {
  ig <- as.igraph(object)
  ids <- igraph::is.directed(ig)
  out <- list()
  out$n_nodes <- nrow(object$interactions)
  out$n_edges <- nrow(object$nodes)
  out$connectance <- out$n_edges/(out$n_nodes*out$n_nodes)
  out$linkage_density <- out$n_edges/out$n_nodes
  out$nodes_summary <- data.frame(
    degree_all = igraph::degree(ig, mode = "all"),
    degree_in = igraph::degree(ig, mode = "in"),
    degree_out = igraph::degree(ig, mode = "out"),
    centr_eigen = igraph::centr_eigen(ig, ids)$vector
  )
  out
}


#' Summarize mgNetworksCollection properties
#'
#' Summarize mgNetworksCollection properties.
#' @rdname get_network_by_id
#' @method summary mgNetworksCollection
#' @export
summary.mgNetworksCollection <- function(object, ...) {
  lapply(object, summary.mgNetwork)
}