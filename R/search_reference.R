#' Search for a specific dataset reference with DOI
#'
#' @param doi `character` a Digital Object Identifier of the article (mandatory arg)
#' @param verbose a `logical`. Should extra information be reported on progress?
#' @param ... further arguments to be passed to [rmangal::get_gen()].
#' @return
#' An object of class `mgSearchReference`, which is essentially a list that include a wide range of details associated to the reference, including all datasets and networks related to the publication that are included in mangal data base.
#' @examples
#' search_reference(doi = "10.2307/3225248")
#' @export

search_reference <- function(doi, verbose = TRUE, ...) {

    stopifnot(is.character(doi) & length(doi) == 1)

    ref <- as.data.frame(get_gen(endpoints()$reference,
      query = list(doi = doi), ...))

    if (verbose) message(sprintf("Found dataset: \n %s", ref$bibtex))

    # Attach dataset
    datasets <- purrr::map(get_from_fkey(endpoints()$dataset, ref_id = ref$id),
      "body")
    ref$datasets <- do.call(rbind,datasets)

    # Attach dataset
    networks <- purrr::map(get_from_fkey(endpoints()$network,
      dataset_id = ref$datasets$id), "body")
    ref$networks <- do.call(rbind, networks)

    class(ref) <- "mgSearchReference"
    ref
}
