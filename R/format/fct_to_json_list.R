#' @title Dataframe into json list
#'
#' @description Convert a dataframe into a list with json data
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

to_json_list <- function(df){

  # Object df must be a dataframe
  if(typeof(df) != "list"){

    stop(" 'df' must be a dataframe")
  }

  # Set df into a list with attribute names as levels
  df <- as.list(setNames(data.table::split(df, seq(nrow(df))), rownames(df)))

  # Set each list level into json
  for (i in 1:length(df)) {

    df[[i]] <- jsonlite::toJSON(df[[i]])
  }

  return(df)
}

print("to_json_list extracted")
