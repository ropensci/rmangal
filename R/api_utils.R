#' Coerce mangalGetResp to data.frame
#'
#' @param responses mangalGetResp class
#' @export

as.data.frame.mgGetResponses <- function(responses){

    bodies <- purrr::map(responses,"body")
    classes <-  unique(unlist(purrr::map(bodies,class)))
    
    # Use the proper binding function based on body classes
    # TODO: Clean enough?

    if("sf" %in% classes){
        return(purrr::reduce(bodies, sf:::rbind.sf)) 
    } else if ("data.frame" %in% classes) {
        return(dplyr::bind_rows(bodies))        
    } else {
        stop("Class of body responses should be data.frame or sf")
    }
}

#' Test on class `coleoGetResponses` (Objet S3)
#' @param x R object to test
#' @export
is.mgGetResponses <- function(x) inherits(x,"mgGetResponses")


#' Summary of response status
#' TODO: Improve display by providing calls that are failed
summary.mgGetResponses <- function(responses) table(purrr::map_chr(x,class))
