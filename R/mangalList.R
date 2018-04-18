#' @title List entry of the table
#' 
#' @description List all objects of a given table
#'
#' @return a list of objects of a given table
#'
#' @param api a \code{\link{mangalapi}} object
#' @param type a type of object
#' @param filtering a vector of filters to restrict the returned objects

mangalList <- function(table, filtering = NULL, attribute){
  
  server <- stringr::str_c(mangal.env$prod$server, mangal.env$base)
  
  url <- stringr::str_c(server, "/", table)
  
  request <- GET(url, config = mangal.env$headers)
  
  if(length(filtering) != 0) attribute <- c(attribute, filtering)

  return(lapply(content(request), "[", attribute))
}

