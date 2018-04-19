#' @title List all entries of the table
#' 
#' @description List all objects of a given table
#'
#' @return A list of objects of a given table
#'
#' @param table a Mangal table name
#' @param attribute a vector of attribute
#' @param filtering a vector of filters to restrict the returned objects

mangalList <- function(table, filtering, attribute){
  
  server <- stringr::str_c(mangal.env$prod$server, mangal.env$base)
  
  url <- stringr::str_c(server, "/", table)
  
  request <- GET(url, config = mangal.env$headers)
  
  if(tolower(httr::http_status(request)$category) == "success"){
  
    if(length(filtering) != 0) attribute <- c(attribute, filtering)

    request <- lapply(content(request), "[", unique(attribute))
    
    for(i in 1:(length(request))){ 
      if(sum(is.na(names(request[[i]]))) >= 1) request[[i]][[which(is.na(names(request[[i]])))]] <- NULL
    } # To improve
    
    return(request)
  
  } else {
      
      stop(httr::http_status(request)$message)
    
    }
}