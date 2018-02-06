#' @title Remove a network
#'
#' @description Remove a network and associated information from Mangal. Delete on cascade
#'
#' @param id A numeric, is the id of the network to remove
#' @param name A character, is the name of the network to remove
# @param Oauth_key A interger, is the Oauth_key of the users/admin/curator.
#'     Users can only remove their own datasets
#'
#' @return
#'
#' The status and information of the resquest
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr
#' @importFrom httr
#' @importFrom httr

DELETE_network <- function(id, name){

  # Connect to API
  server <- "http://localhost:3000"

  # Set the id and name as path
  url <- httr::modify_url(server, path = paste0("/api/v0/networks", "?", "id=", id, "&name=", name))

  # Change space in url by "_"
  url <- gsub(" ", "%20", url)

  # Store status of DELETE request
  status <- DELETE(url = url)

  http_status(status)[[3]]
}
