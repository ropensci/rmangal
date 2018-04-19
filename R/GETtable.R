#' @title Get informations of a given table
#'
#' @description Returns an object
#' 
#' @return A list
#'
#' @param id the ID of the object
#' @param table a Mangal table name
#' @param filtering a vector of filters to restrict the returned objects
#' @param atribute a vector of attribute

GetTable <- function(id, filtering, table, attribute){
  
  if((length(id) != 0) == TRUE) { mangalGet(id, table, filtering, attribute)
  
    } else { mangalList(table, filtering, attribute)
  }
}