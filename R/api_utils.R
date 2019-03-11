#' Coerce 
#'
#' @param responses liste de réponse des fonctions de GET/POST
#' @export

as.data.frame.mangalGetResp <- function(responses=responses, ...){

    return(tibble::as_tibble(all_body <- do.call(
        plyr::rbind.fill,
        lapply(responses, function(page){
        return(page$body)
        })
    )))

}

#' Class test `coleoGetResp` (Objet S3)
#' @param x Objet à tester
#' @export
is.mangalGetResp <- function(x) inherits(x,'mangalGetResp')

#' Class test `coleoPostResp` (Objet S3)
#' @param x Objet à tester
#' @export
is.mangalPostResp <- function(x) inherits(x,'mangalPostResp')
