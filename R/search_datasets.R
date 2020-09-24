#' Query datasets
#'
#' Identify relevant datasets using a keyword or a custom query.
#' If the `query` is a character string, then all character columns in the table
#' are searched and the entries for which at least one
#' partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a specific column (see Details section)
#'
#' @param query either a character string including a single keyword or a list containing a custom query (see details section below).
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param verbose a logical. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [httr::GET()].
#'
#' @return
#' An object of class `mgSearchDatasets`, which basically is a `data.frame`
#' including all datasets corresponding to the query. For each dataset entry, 
#' the networks and the original reference are attached.
#'
#' @details
#' Names of the list should match one of the column names within the table. 
#' For the `dataset` table, those are:
#' - id: unique identifier of the dataset
#' - name: name of the dataset
#' - date: date (`YYYY-mm-dd`) of the corresponding publication
#' - description: a brief description of the data set
#' - ref_id: the Mangal identifier of the dataset
#'
#' Note that for lists with more than one element, only the first element is used, the others are ignored.
#' Examples covering custom queries are provided below.
#'
#' @references
#' Metadata available at <https://mangal-wg.github.io/mangal-api/#datasets>
#'
#' @examples
#' \donttest{
#' # Return all datasets (takes time)
#' all_datasets <- search_datasets("", verbose = FALSE)
#' all_datasets
#' class(all_datasets)
#' }
#' # Search with keyword
#' mg_lagoon <- search_datasets(query = 'lagoon', verbose = FALSE)
#' # Search with a custom query (specific column)
#' mg_kemp <- search_datasets(query = list(name = 'kemp_1977'), verbose = FALSE)
#' mg_16 <- search_datasets(query = list(ref_id = 16), verbose = FALSE)
#' @export

search_datasets <- function(query, verbose = TRUE, ...) {

  query <- handle_query(query, c("id", "name", "date", "description", "ref_id"))
  datasets <- resp_to_df(get_gen(endpoints()$dataset, query = query,
    verbose = verbose, ...)$body)

  if (is.null(datasets)) {
    if (verbose) message("No dataset found.")
    return(data.frame())
  } else {
    if (verbose) message(sprintf("Found %s datasets", nrow(datasets)))
  }

  # Attached references and networks
  # No need for test because if NULL function stopped above
  references <- networks <- list()

  for (i in seq_len(nrow(datasets))) {

    # Appending networks
    tmp_networks <- get_from_fkey_net(endpoints()$network,
      dataset_id = datasets$id[i], verbose = verbose)
    if (!is.null(tmp_networks)) {
      networks[[i]] <- tmp_networks
    } else networks[[i]] <- NA

    # Appending references
    tmp_references <- resp_to_df(get_singletons(endpoints()$reference,
      ids = datasets$ref_id[i], verbose = verbose)$body)
    if (!is.null(tmp_references)) {
      references[[i]] <- tmp_references
    } else references[[i]] <- NA

  }
  
  datasets$references <- references
  datasets$networks <- networks

  class(datasets) <- c("tbl_df", "tbl", "data.frame", "mgSearchDatasets")
  datasets
}
