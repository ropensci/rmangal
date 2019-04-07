#' Search over all datasets using keyword
#'
#' @param query a `character` string containing a keyword used to search (case sensitive),
#' or a `list` containing a custom query (see examples). 
#' If keyword is unspecified (query = NULL), all datasets will be returned.
#' @param verbose a logical. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @return
#' An object of class `mgSearchDatasets`, which is a `data.frame`  object with all datasets corresponding to the query. 
#' For each dataset entry, the networks and the original reference are attached.
#' @examples
#' \dontrun{
#' # Return all dataset
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

search_datasets <- function(query = NULL, verbose = TRUE, ...) {

  # Full search
  if (is.character(query)) {
    query <- list(q = query)
  }

  datasets <- as.data.frame(get_gen(endpoints()$dataset, query = query, ... ))

  if (verbose) message(sprintf("Found %s datasets", nrow(datasets)))

  # Attached reference and network
  networks <- list()
  references <- list()

  for (i in seq_len(nrow(datasets))) {
    networks[[i]] <- as.data.frame(get_from_fkey(endpoints()$network,
      dataset_id = datasets[i, "id"]))
    references[[i]] <- as.data.frame(get_singletons(endpoints()$reference,
      ids = datasets[i, "ref_id"]))
  }

  if (nrow(datasets) > 0) {
    datasets$networks <- networks
    datasets$references <- references
  }

  class(datasets) <- append(class(datasets), "mgSearchDatasets")
  datasets

}
