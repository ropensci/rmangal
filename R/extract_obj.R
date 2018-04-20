#' @title extract_obj
#'
#' @description extract object from a table based on foreign keys, return as vector or dataframe
#' 
#' @return a vector or dataframe with the extracted object
#'
#' @param id IDs of the foreing keys
#' @param table targeted table
#' @param frmt format (vector or dataframe)
#' @param filter which attribute to extract
#' @param match which attribute to match (name of the forein key)

extract_obj <- function(id, table, frmt, filter, match){
  # frmt should be an enum
  
  server <- stringr::str_c(mangal.env$prod$server, mangal.env$base)
  
  if(frmt == "vector"){ rqst <- vector()
  # frmt should be an enum
  
    } else { rqst <- data.frame()
  }
  
  for(i in 1:length(id)){
    for (j in 1:length(match)) {
      
      url <- stringr::str_c(server, "/", table, "/?", match[j], "=", id[i])
    
      data <- httr::GET(url, config = mangal.env$headers)
      data <- lapply(httr::content(data), "[", filter)
    
      if(length(data) != 0){
        if(frmt == "vector"){ rqst <- c(rqst, as.vector(unlist(data)))
        # frmt should be an enum
    
          } else { 
            rqst <- rbind(rqst, as.data.frame(matrix(unlist(data), ncol = length(filter), byrow = TRUE)))
        }
      }
    }
  }
  
  if(class(rqst) == "data.frame") colnames(rqst) <- filter
  rqst <- unique(rqst)
  return(rqst)
  
}
