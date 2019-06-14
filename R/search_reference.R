#' Search for a specific dataset reference with DOI
#'
#' @param doi `character` a Digital Object Identifier of the article (mandatory arg).
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @return
#' An object of class `mgSearchReference`, which is essentially a list that include a wide range of details associated to the reference, including all datasets and networks related to the publication that are included in mangal data base.
#' @examples
#' search_reference(doi = "10.2307/3225248")
#' @export

search_reference <- function(doi, verbose = TRUE, ...) {

  stopifnot(is.character(doi) & length(doi) == 1)

  ref <- resp_to_df(get_gen(endpoints()$reference, query = list(doi = doi), ...)$body)

  if (verbose)
    message(sprintf("Found dataset: \n %s", ref$bibtex))

  # Attach dataset
  ref$datasets <- get_from_fkey(endpoints()$dataset, ref_id = ref$id)

  # Attach network
  ref$networks <- get_from_fkey_net(endpoints()$network, dataset_id = ref$datasets$id)

  class(ref) <- "mgSearchReference"
  ref
}
