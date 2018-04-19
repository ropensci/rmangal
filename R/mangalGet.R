#' @title Get an entry of a given table
#'
#' @description Returns an object
#' 
#' @return A list
#'
#' @param id the ID of the object
#' @param table a Mangal table name
#' @param filtering a vector of filters to restrict the returned objects
#' @param atribute a vector of attribute

mangalGet <- function(id, table, filtering, attribute){
  
  if((class(id) != "numeric") == TRUE | (length(id) != 1) == TRUE) stop(stringr::str_c("'id' must contain only one numeric"))
  
  server <- stringr::str_c(mangal.env$prod$server, mangal.env$base)
  
  url <- stringr::str_c(server, "/", table, "/?id=", id)
  
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