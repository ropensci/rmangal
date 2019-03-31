#' Search for a specific data sset reference with DOI
#'
#' @param doi `character` a Digital Object Identifier of the article which the
#' network is attached.
#' @param verbose a logical. Should extra information be reported on progress?
#' @return
#' An object of class mgSearchReference`, which is essentially a
#' `data.frame` object with the reference corresponding to the query. Note that
#' all datasets and networks related to the publication are also attached to the
#' `data.frame`.
#'
#' @examples
#' search_reference(doi = "10.2307/3225248")
#' @export

search_reference <- function(doi = NULL, verbose = TRUE) {

    stopifnot(is.character(doi) & length(doi) == 1)

    ref <- as.data.frame(get_gen(endpoints()$reference,
      query = list(doi = doi)))

    if (verbose) message(sprintf("Found dataset: \n %s", ref$bibtex))

    # Attach dataset
    datasets <- purrr::map(get_from_fkey(endpoints()$dataset, ref_id = ref$id),
      "body")
    ref$datasets <- do.call(rbind,datasets)

    # Attach dataset
    networks <- purrr::map(get_from_fkey(endpoints()$network,
      dataset_id = ref$datasets$id),"body")
    ref$networks <- do.call(rbind, networks)

    class(ref) <- "mgSearchReference"
    ref
}
