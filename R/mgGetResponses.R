#' Coerce mgGetResponses to data.frame
#'
#' Coerce mgGetResponses to data.frame
#' @param x object of class `mgGetResponses`.
#' @param ... ignored
#' @export
as.data.frame.mgGetResponses <- function(x, ...) {

    classes <- unique(unlist(purrr::map(purrr::map(x, "body"), class)))

    # Use the proper binding function based on body classes
    if ("sf" %in% classes){
        return(purrr::reduce(purrr::map(x, "body"), rbind))
    } else {
        return(dplyr::bind_rows(purrr::map(x, "body")))
    }
}


#' Summarize response status
#' @param object object of class `mgGetResponses`.
#' @param ... ignored
#' @export
summary.mgGetResponses <- function(object, ...) table(purrr::map_chr(object,
  class))


#' Test class `coleoGetResponses`
#' @param x R x to test
#' @export
is.mgGetResponses <- function(x) inherits(x, "mgGetResponses")
