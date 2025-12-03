#' Query references
#'
#' Search for a specific reference using a keyword or a Digital Object
#' Identifier (DOI).
#' If the `query` is a character string, then all character columns in the table
#' are searched and the entries for which at least one
#' partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a
#' specific column (see Details section).
#'
#' @inheritParams search_datasets
#' @param doi `character` a Digital Object Identifier  (DOI) of the article.
#' Note that `query` is ignored if `doi` is specified.
#'
#' @return
#' An object of class `mgSearchReferences`, which is a list that includes a
#' wide range of details associated to the reference, including all datasets
#' and networks related to the publication that are included in Mangal database.
#'
#' @details
#' Names of the list should match one of the column names within the table.
#' For the `reference` table, those are:
#' * `id`: unique identifier of the reference
#' * `first_author`: first author
#' * `doi`: use `doi` instead
#' * `jstor`: JSTOR identifier
#' * `year`: year of publication.
#'
#' Note that for lists with more than one element, only the first element is
#' used, the others are ignored. An example is provided below.
#'
#' @references
#' * <https://mangal.io/#/>
#' * <https://mangal-interactions.github.io/mangal-api/#references>
#'
#' @examples
#' \donttest{
#' search_references(doi = "10.2307/3225248")
#' search_references(list(jstor = 3683041))
#' search_references(list(year = 2010))
#' }
#' @export

search_references <- function(query, doi = NULL, ...) {
  if (!is.null(doi)) {
    if (length(doi) > 1) {
      cli::cli_warn("Only the first doi is used.")
      doi <- doi[1L]
    }
    query <- list(doi = as.character(doi))
  } else {
    query <- handle_query(query, c("id", "author", "doi", "jstor", "year"))
  }

  ref <- rmangal_request(
    endpoint = "reference", query = query, ...
  )$body |>
    resp_to_df()

  if (is.null(ref)) {
    rmangal_inform("No reference found!")
    return(data.frame())
  }
  rmangal_inform("Found {nrow(ref)} reference{?s}.")

  # Attach dataset(s)
  ref$datasets <- do.call(
    rbind,
    lapply(ref$id, \(x) get_from_fkey("dataset", ref_id = x))
  )

  # Attach network(s)
  ref$networks <- lapply(
    ref$datasets$id,
    \(x) {
      rmangal_request(
        endpoint = "network", query = list(dataset_id = x)
      )$body[[1]] |>
        null_to_na()
    }
  ) |>
    lapply(resp_to_spatial)

  class(ref) <- "mgSearchReferences"
  ref
}
