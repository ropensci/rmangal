#' @title Dataframe into json list
#'
#' @description Convert a dataframe into a list of json data
#'
#' @param df A dataframe, header must be the names of attributes
#'
#' @return
#'
#' A list of json data, each level of the list is ready for injection in Mangal
#'
#' @author Gabriel Bergeron
#'
#' @keywords manip
#'
#' @importFrom jsonlite toJSON
#' @importFrom data.table split

json_list <- function(df){

  # Object df must be a dataframe
  if(any(class(df) == "data.frame")){

  # Set df into a list with attribute names as levels
  df <- as.list(setNames(split(df, seq(nrow(df))), rownames(df)))

  # Set each list level into json
  for (i in 1:length(df)) df[[i]] <- jsonlite::toJSON(df[[i]])

  return(df)

  } else { stop(" 'df' must be a data.frame") }

}

