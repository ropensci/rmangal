#' Search for a specific reference with DOI 
#'
#' @param doi `character` Digital Object Identifier of the article which the network is attached.
#' @return
#' `data.frame` object with the reference corresponding to the query. All datasets and networks related to the publication are also attached to the `data.frame`.
#'  Class returned `mgSearchReference`
#' @examples
#' search_reference(doi = "10.2307/3225248")
#' @export

search_reference <- function( doi = NULL ) {

    stopifnot(is.character(doi) & length(doi) == 1)

    ref <- as.data.frame(get_gen(endpoints()$reference, query = list( doi = doi )))

    message(sprintf("Found dataset: \n %s", ref$bibtex))

    # Attach dataset
    datasets <- purrr::map(get_from_fkey(endpoints()$dataset, ref_id = ref$id),"body")
    ref$datasets <- do.call(rbind,datasets)

    # Attach dataset
    networks <- purrr::map(get_from_fkey(endpoints()$network, dataset_id = ref$datasets$id),"body")
    ref$networks <- do.call(rbind,networks)

    class(ref) <- "mgSearchReference"
    ref

}
