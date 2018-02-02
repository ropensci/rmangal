#' @title POST many lines of json data on a same Mangal table
#'
#' @description POST a list of json data in the Mangal table specified by the user
#'
#' @param data_lst A list with data to be injected, must be json
#' @param table A element, must be the name of the targeted table with ""
#'
#' @return
#'
#' The status and line of failed attempt; if none -> empty
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr status_code
#' @importFrom httr http_status

POST_table <- function(data_lst, table) {

  # Create vector of status that will contain line + error message
  status <- vector()

  # Stock responce status for 1 iteration
  resp <- character()

  # loop : POST one by one each line of the table
  for (j in 1:length(data_lst)) {

    # Get the status of the POST in resp
    resp <- POST_line(data_lst[[j]], table)

    # Check if status code other than "Created"
    if(httr::status_code(resp) != 201){

      # If so, paste line + status message
      status[length(status)+1] <- paste(j, httr::http_status(resp)[[3]])
    }
  }
  # View wich request failed
  if(length(status) != 0){
    print(status)
  }
}

print("POST_table extracted")
