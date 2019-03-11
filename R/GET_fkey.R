#' @title GET id key from a Mangal entry
#'
#' @description GET primary key of a table entry specified by the user
#'
#' @param enpoint A element, must be the name of the targeted table with ""
#' @param param A element, must be the name of the targeted attribute with ""
#' @param value A element, must be the value of the targeted attribute with ""
#'
#' @return
#'
#' The value of the primary key of a specified entry
#'
#' @author Gabriel Bergeron & Steve Vissault
#'
#'
#' @export

GET_fkey <- function(url = NULL, params = ){

  if(length(attribute) != length(value)) stop("attributes and values not the same vectors length")

  # Connect to API
  server <- mangal.env$prod$server

  # Set the table and name as path
  url <- httr::modify_url(server, path = paste0(mangal.env$base, "/", table, "?"))

  # If lenght of attribute & value > 1, then proceed to complex request
  if((length(attribute) == 1 & length(value) == 1) == TRUE){


  # Retreive data from Mangal
  data <- httr::GET(url, config = mangal.env$headers)
  if(http_error(data) == TRUE) stop(paste("Bad request for", url))
  
  data <- httr::content(data)
  if((length(data) > 1) == TRUE) stop(paste0("more than one entry for ",  url))

  # Get data into vector
  data <- unlist(data)

  if(is.null(data[[1]] == TRUE)){

    print("wrong attribute, check spelling; value or table inexistant, no associated id")

  } else {

    return(data[[1]])

    }
}
