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
#' @importFrom httr http_error
#' @importFrom httr http_status
#'
#' @export

POST_table <- function(data_lst, table) {

  if(class(data_lst) != "list") stop("data_lst must be a list")

  # Create vector of status that will contain line + error message
  status <- vector()

  # Stock responce status for 1 iteration
  resp <- character()

  # loop : POST one by one each line of the table
  for (j in 1:length(data_lst)) {

    # Get the status of the POST in resp
    resp <- POST_line(data_lst[[i]], table)

    # Check if status code other than "Created"
    if(httr::http_error(resp) == TRUE){

      # If so, paste line + status message
      error_code <- httr::http_status(resp)[[3]]
      error_content <- unlist(sapply(httr::content(resp)$errors, "[", 2))
      
      for(k in 1: length(error_content)){
        status[length(status)+k] <- paste(j, error_code, "\nReason :", error_content[k])
      }
    }
  }
  # View wich request failed
  
  if(length(status) != 0) cat(paste0("----------------------------\nEntries that failed: ",na.omit(status),"\n----------------------------"), sep = "")

  else print("No entry failed")
}
