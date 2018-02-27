#' @title POST a line of json data into a Mangal table
#'
#' @description POST a line of json data into the Mangal table specified by the user
#'
#' @param table_lst_line A json line of data
#' @param table A element, must be the name of the targeted table with ""
#'
#' @return
#'
#' The status of the request
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom jsonlite unbox

# Table must be inside " "
POST_line <- function (table_lst_line, table) {

  # Data.line must be of class JSON
  if(class(table_lst_line) != "json") stop(" 'table_lst_line' must be a json")

  # Connect to API
  server <- "http://localhost:3000"

  # Set the "table" as path
  path <- httr::modify_url(server, path = paste0("/api/v0/",table))

  # Post a line of data
  httr::POST(path, body = unbox(table_lst_line), config = add_headers("Content-type" = "application/json"))
}
