#' Combine Mangal networks
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
#' mg_random_1071 <- get_collection(c(1071), verbose = FALSE)
#' mg_random_1074 <- get_collection(c(1074), verbose = FALSE)
#' combine_mgNetworks(mg_random_1071, mg_random_1074)
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
