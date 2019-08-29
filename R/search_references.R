#' Query references
#'
#' Search for a specific reference using a key wor or a Digital Object Identifier (DOI).
#' If the `query` is a character string, then all character columns in the table
#' are searched and the entries for which at least one
#' partial match was found are returned.
#' Alternatively, a named list can be used to look for an exact match in a specific column (see Details section)
#'
#' @param query either a character string including a single keyword or a list containing a custom query (see details section below).
#' Note that if an empty character string is passed, then all datasets available are returned.
#' @param doi `character` a Digital Object Identifier  (DOI) of the article. Note that `query` is ignored if `doi` is specified.
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [httr::GET()].
#'
#' @return
#' An object of class `mgSearchReferences`, which is a list that includes a wide range of details associated to the reference, including all datasets and networks related to the publication that are included in Mangal database.
#'
#' @details
#' Names of the list should match one of the column names within the table. 
#' For the `reference` table, those are:
#' - id: unique identifier of the reference
#' - first_author: first author
#' - doi: use `doi` instead
#' - jstor: JSTOR identifier
#' - year: year of publication.
#'
#' Note that for lists with more than one element, only the first element is used, the others are ignored. An example is provided below.
#'
#' @references
#' More metadata on <https://mangal-wg.github.io/mangal-api/#references>
#'
#' @examples
#' search_references(doi = "10.2307/3225248")
#' search_references(list(jstor = 3683041))
#' @export

search_references <- function(query, doi = NULL, verbose = TRUE, ...) {

  if (!is.null(doi)) {
    if (length(doi) > 1) {
      warning("Only the first doi is used.")
      doi <- doi[1L]
    }
    query <- list(doi = as.character(doi))
  } else query <- handle_query(query, c("id" ,"author", "doi", "jstor", "year"))


  ref <- resp_to_df(get_gen(endpoints()$reference, query = query,
    verbose = verbose, ...)$body)

  if (is.null(ref)) {
     if (verbose) message("No dataset found!")
     return(data.frame())
   }

  if (verbose)
    message(sprintf("Found %s reference", nrow(ref)))

  # Attach dataset
  ref$datasets <- get_from_fkey(endpoints()$dataset, ref_id = ref$id,
    verbose = verbose)

  # Attach network
  ref$networks <- get_from_fkey_net(endpoints()$network,
    dataset_id = ref$datasets$id, verbose = verbose)

  class(ref) <- "mgSearchReferences"
  ref
}
