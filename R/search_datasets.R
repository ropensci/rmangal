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
#' res2011 <- search_datasets(query = '2011')
#' # Search with custom query (specific column)
#' search_datasets(query = list(name = 'kemp_1977'))
#' @export

search_datasets <- function(query = NULL, verbose = TRUE, ...) {

  # Full search
  if (is.character(query))
    query <- list(q = query)

  datasets <- resp_to_df(get_gen(endpoints()$dataset, query = query, ...)$body)

  if (is.null(datasets)) {
    if (verbose)
      message("No dataset found.")
    return(data.frame())
  } else {
    if (verbose)
      message(sprintf("Found %s datasets", nrow(datasets)))
  }

  # Attached references and networks
  # No need for test because if NULL function stopped above
  references <- networks <- NULL
  for (i in seq_len(nrow(datasets))) {
    networks[[i]] <- get_from_fkey_net(endpoints()$network, dataset_id = datasets$id[i])
    references[[i]] <- resp_to_df(get_singletons(endpoints()$reference, ids = datasets$ref_id[i])$body)
  }
  datasets$references <- references
  datasets$networks <- networks

  class(datasets) <- c("tbl_df", "tbl", "data.frame", "mgSearchDatasets")
  datasets

}
