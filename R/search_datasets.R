#' Query datasets
#'
#' Identify relevant datasets using a keyword or a custom query.
#' If the `query` is a character string, then all character columns in the table
#' are searched and the entries for which at least one
#' partial match was found are returned. Alternatively, a named list can be
#' used to look for an exact match in a specific column (see Details section).
#'
#' @param query either a character string including a single keyword or a named
#' list containing a custom query (see details section below). Note that if an
#' empty character string is passed, then all available entries are returned.
#' @param ... Further arguments passed to [rmangal_request()], including the 
#' argument `cache` that allows requests caching.
#'
#' @return
#' An object of class `mgSearchDatasets`, which basically is a `data.frame`
#' object including all datasets corresponding to the query. For each dataset
#' entry, the networks and the original reference are attached.
#'
#' @details
#' If `query` is a named list, the name  used should be one of the following:
#' - id: unique identifier of the dataset
#' - name: name of the dataset
#' - date: date (`YYYY-mm-dd`) of the corresponding publication
#' - description: a brief description of the data set
#' - ref_id: the Mangal identifier of the dataset
#'
#' Note that for lists with more than one element, only the first element is
#' used, the others are ignored. Examples covering custom queries are provided
#' below.
#'
#' @references
#' * <https://mangal.io/#/>
#' * <https://mangal-interactions.github.io/mangal-api/#datasets>
#'
#' @examples
#' \donttest{
#' # Return all datasets (takes time)
#' # all_datasets <- search_datasets("")
#' # all_datasets
#' # class(all_datasets)
#' # Search with keyword
#' mg_lagoon <- search_datasets(query = "lagoon")
#' # Search with a custom query (specific column)
#' mg_kemp <- search_datasets(query = list(name = "kemp_1977"))
#' mg_16 <- search_datasets(query = list(ref_id = 16))
#' }
#' @export

search_datasets <- function(query, ...) {
  query <- handle_query(query, c("id", "name", "date", "description", "ref_id"))
  datasets <- rmangal_request(endpoint = "dataset", query = query, ...)$body |>
    resp_to_df()

  if (is.null(datasets)) {
    rmangal_inform("No dataset found.")
    return(data.frame())
  } else {
    rmangal_inform("Found {nrow(datasets)} dataset{?s}.")
  }

  # Attached references and networks
  # No need for test because if NULL function stopped above
  datasets$networks <- lapply(
    datasets$ref_id,
    \(x) {
      rmangal_request("network", query = list(dataset_id = x))$body |>
        lapply(resp_to_spatial) |>
        do.call(what = rbind)
    }
  )

  datasets$references <- lapply(
    datasets$ref_id,
    \(x) {
      rmangal_request_singleton("reference", id = x)$body |>
        null_to_na() |>
        as.data.frame()
    }
  )

  class(datasets) <- c("tbl_df", "tbl", "data.frame", "mgSearchDatasets")
  datasets
}
