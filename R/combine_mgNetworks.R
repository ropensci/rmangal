#' Combine Mangal networks.
#'
#' Combine `mgNetworksCollection` and `mgNetwork` objects into a
#' `mgNetworksCollection` object.
#'
#' @param ... objects of class `mgNetworksCollection` or `mgNetwork` or a list #' of objects of these classes.
#'
#' @return
#' An object of class `mgNetworksCollection`
#'
#' @examples
#' mg_37 <- get_collection(search_networks(list(dataset_id = 37)), verbose = FALSE)
#' mg_anemone <- get_collection(search_datasets(query='anemone%'), verbose = FALSE)
#' combine_mgNetworks(mg_37, mg_anemone)
#'
#' @export
combine_mgNetworks <- function(...) {
  lsmg <- list(...)
  if (length(lsmg) == 1) {
    if (class(lsmg[[1L]]) == "mgNetwork") {
      return(structure(list(lsmg), class = "mgNetworksCollection"))
    } else lsmg <- unlist(lsmg, recursive = FALSE)
  }
   structure(do.call(c, lapply(lsmg, unlist_mgNetworks)),
    class = "mgNetworksCollection")
}

unlist_mgNetworks <- function(x) {
    if (class(x) == "mgNetworksCollection") {
      unclass(x)
    } else {
      if (class(x) == "mgNetwork") {
        list(x)
      } else stop("Only 'mgNetwork' and `mgNetworksCollection` objects are
        supported")
    }
  }
