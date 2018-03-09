#' @title GET id key from a Mangal entry
#'
#' @description GET primary key of a table entry specified by the user
#'
#' @param table A element, must be the name of the targeted table with ""
#' @param attribute A element, must be the name of the targeted attribute with ""
#' @param value A element, must be the value of the targeted attribute with ""
#'
#' @return
#'
#' The value of the primary key of a specified entry
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr content
#'
#' @export

GET_fkey <- function(table, attribute, value){

  if(length(attribute) != length(value)) stop("attribute and value not of the same length")

  # Connect to API
  server <- "http://localhost:3000"

  # Set the table and name as path
  url <- httr::modify_url(server, path = paste0("/api/v0/", table, "/?"))

  # If lenght of attribute & value > 1, then proceed to complex request
  if((length(attribute) == 1 & length(value) == 1) == TRUE){

  # Change space in url by "_"
  url <- gsub(" ", "%20", paste0(url, attribute, "=", value))

  } else {

    url <- gsub(" ", "%20", paste0(url, paste0(attribute, "=", value, collapse = "&")))
  }

  # Retreive data from Mangal
  data <- httr::GET(url)
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
