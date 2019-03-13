#' Coerce mangalGetResp to data.frame
#'
#' @param responses mangalGetResp class
#' @export

as.data.frame.mangalGetResp <- function(responses=responses, ...){
    return(dplyr::bind_rows(purrr::map(responses, "body")))
}

#' Test on class `coleoGetResp` (Objet S3)
#' @param x Objet à tester
#' @export
is.mangalGetResp <- function(x) inherits(x,'mangalGet')

#' Test on class `coleoPostResp` (Objet S3)
#' @param x Objet à tester
#' @export
is.mangalPostResp <- function(x) inherits(x,'mangalPost')
