#' Coerce mgGetResponses to data.frame
#'
#' @param responses mgGetResponses class
#' @export

as.data.frame.mgGetResponses <- function(responses){

    classes <-  unique(unlist(purrr::map(purrr::map(responses,"body"),class)))

    # Use the proper binding function based on body classes
    if("sf" %in% classes){
        return(purrr::reduce(purrr::map(responses,"body"), sf::rbind.sf)) 
    } else {
        return(dplyr::bind_rows(purrr::map(responses,"body")))        
    }
}

#' Test class `coleoGetResponses` 
#' @param x R object to test
#' @export
is.mgGetResponses <- function(x) inherits(x,"mgGetResponses")


#' Summary of response status
#' @param responses mgGetResponses class
#' @export
summary.mgGetResponses <- function(responses) table(purrr::map_chr(x,class))
