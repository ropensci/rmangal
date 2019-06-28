#' Search for a specific dataset reference with its DOI
#'
#' @param query `character` a Digital Object Identifier of the article (mandatory arg).
#' @param doi `character` a Digital Object Identifier of the article (mandatory arg).
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @return
#' An object of class `mgSearchReference`, which is essentially a list that includes a wide range of details associated to the reference, including all datasets and networks related to the publication that are included in mangal data base.
#'
#' @references
#' <https://mangal-wg.github.io/mangal-api/#references>
#'
#' @examples
#' search_reference(doi = "10.2307/3225248")
#'
#' @export

search_reference <- function(query, doi = NULL, verbose = TRUE, ...) {

  if (!is.null(doi)) {
    stopifnot(length(doi) == 1)
    query <- list(doi = as.character(doi))
  } else query <- list(q = as.character(query))


  ref <- resp_to_df(get_gen(endpoints()$reference, query = query,
   ...)$body)

  if (is.null(ref)) {
     if (verbose) message("No dataset found!")
     return(data.frame())
   }

  if (verbose)
    message(sprintf("Found dataset: \n %s", ref$bibtex))

  # Attach dataset
  ref$datasets <- get_from_fkey(endpoints()$dataset, ref_id = ref$id)

  # Attach network
  ref$networks <- get_from_fkey_net(endpoints()$network,
    dataset_id = ref$datasets$id)

  class(ref) <- "mgSearchReference"
  ref
}
