#' Retrieve network information, nodes, edges and references for a given set of Mangal network IDs
#'
#' @param ids a vector of Mangal ID for networks (`numeric`).
#' @param id a single ID network (`numeric`).
#' @param x an object of class `mgNetwork` or `mgNetworksCollection`.
#' @param object object of of class `mgNetwork` or `mgNetworksCollection`.
#' @param as_sf a logical. Should networks metadata be converted into an sf
#' object? Note that to use this feature `sf` must be installed.
#' @param force_collection a logical. Should the output to be of class
#' `mgNetworksCollection` even if it includes only one network.
#' @param ... ignored.
#'
#' @rdname get_network_by_id
#'
#' @return
#' A `mgNetwork` object includes five data frames:
#' * network: includes all generic information on the network (if `as_sf=TRUE`
#' then it is an object of class `sf`);
#' * nodes: information pertaining to nodes (includes taxonomic information);
#' * interactions: includes ecological interactions and their attributes;
#' * dataset: information pertaining to the original dataset;
#' * reference: details about the original publication.
#'
#' A summary method is available for objects of class `mgNetwork` object and
#' returns the following network properties:
#' * the number of nodes;
#' * the number of edges;
#' * the connectance;
#' * the linkage density;
#' * the degree (in, out an total) and the eigenvector centrality of every nodes.
#'
#' @examples
#' \donttest{
#' net18 <- get_network_by_id(id = 18)
#' net18_c <- get_network_by_id(id = 18, force_collection = TRUE)
#' nets <- get_network_by_id(id = c(18, 23))
#' }
#' @export

get_network_by_id <- function(ids, as_sf = FALSE, force_collection = FALSE) {
  if (!length(ids)) {
    cli::cli_warn("length(ids) is 0, an empty dataframe is returned.")
    return(data.frame())
  } else {
    if (length(ids) == 1 && !force_collection) {
      get_network_by_id_indiv(ids, as_sf = as_sf)
    } else {
      structure(
        lapply(ids, get_network_by_id_indiv, as_sf = as_sf),
        class = "mgNetworksCollection"
      )
    }
  }
}


#' @describeIn get_network_by_id Retrieve a network by its collection of networks (default).
#' @export
get_network_by_id_indiv <- function(id, as_sf = FALSE) {
  id <- as.numeric(id)
  stopifnot(length(id) == 1 & !is.na(id))
  net <- rmangal_request_singleton("network", id = id)

  mg_network <- structure(
    list(
      network = net$body |>
        lapply(resp_to_spatial, as_sf = as_sf) |>
        do.call(what = rbind)
    ),
    class = "mgNetwork"
  )

  if (is.null(mg_network$network)) {
    cli::cli_abort("network id {id} not found.")
  }

  mg_network$nodes <- get_from_fkey_flt("node",
    network_id = mg_network$network$id
  )

  mg_network$interactions <- get_from_fkey_flt("interaction",
    network_id = mg_network$network$id
  )

  # retrieve dataset informations
  mg_network$dataset <- rmangal_request_singleton("dataset",
    id = unique(mg_network$network$dataset_id)
  )$body |>
    list() |>
    resp_to_df()

  # retrieve reference
  mg_network$reference <- rmangal_request_singleton("reference",
    id = unique(mg_network$dataset$ref_id)
  )$body |>
    list() |>
    resp_to_df()


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
  print_net_info(
    x$network$network_id, x$dataset$dataset_id, x$network$description,
    nrow(x$interactions), nrow(x$nodes)
  )
  print_taxo_ids(x$nodes)
  print_pub_info(x$reference)
  invisible(x)
}

#' @rdname get_network_by_id
#' @method print mgNetworksCollection
#' @param n maximum number of networks to display.
#' @export
print.mgNetworksCollection <- function(x, n = 6, ...) {
  cli::cli_h2("Network Collection")
  cli::cli_text(
    "{cli::pluralize('{length(x)} network{?s}') |> cli::col_green()}
    in collection"
  )
  nb <- min(length(x), n)
  for (i in seq_len(nb)) print(x[[i]])
  if (length(x) > n) {
    cli::pluralize("# {cli::symbol$info} {length(x) - n} network{?s} not shown.") |>
      cli::col_grey() |>
      cli::cli_text()
    cli::col_grey("# Use `print(..., n = )` 'to show more networks.") |>
      cli::cli_text()
  }
  invisible(x)
}


#' Summarize mgNetwork properties
#'
#' Summarize mgNetwork properties.
#' @rdname get_network_by_id
#' @method summary mgNetwork
#' @export
summary.mgNetwork <- function(object, ...) {
  ig <- as.igraph(object)
  ids <- igraph::is_directed(ig)
  out <- list()
  out$n_nodes <- nrow(object$nodes)
  out$n_edges <- nrow(object$interactions)
  out$connectance <- out$n_edges / (out$n_nodes * out$n_nodes)
  out$linkage_density <- out$n_edges / out$n_nodes
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
