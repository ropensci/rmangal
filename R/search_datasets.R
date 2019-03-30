#' Search mangal datasets
#'
#' @param query a `character` string containing a keyword used to search (case sensitive), or `list`of custom query (see examples).
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @return
#' object `data.frame`: Datasets with all networks and the original reference attached.
#' @examples
#' \dontrun{
#' all_datasets <- search_datasets()
#' all_datasets
#' class(all_datasets)
#' }
#' # Search with keyword
#' search_datasets(query = 'lagoon')
#' search_datasets(query = '2011')
#' # Search with custom query (specific column)
#' search_datasets(query = list(name = 'kemp_1977'))
#' @export

search_datasets <- function(query = NULL, ...) {

  # Full search
  if (is.character(query)) {
    query <- list(q = query)
  }

  datasets <- as.data.frame(get_gen(endpoints()$dataset, query = query, ...))

  if (!is.null(query)) {
    message(sprintf("Found %s dataset(s) for query: %s", nrow(datasets), query))
  }

  # Attached reference and network
  networks <- list()
  references <- list()

  for (i in seq_len(nrow(datasets))) {
    networks[[i]] <- purrr::map_df(get_from_fkey(endpoints()$network, dataset_id = datasets[i, "id"]), "body")
    references[[i]] <- purrr::map_df(get_singletons(endpoints()$reference, ids = datasets[i, "ref_id"], output = "data.frame"), "body")
  }

  if (nrow(datasets) > 0) {
    datasets$networks <- networks
    datasets$references <- references
  }

  class(datasets) <- append(class(datasets), "mgSearchDatasets")
  datasets

}
