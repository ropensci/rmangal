#' @title Update taxon_id in the table taxons
#'
#' @description GET the foreign key 'taxon_id' from the table taxo_backs and update it in the table taxons
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr add_headers
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom jsonlite toJSON
#' @importFrom stringr word

## Update taxon_id
PUT_taxa_id <- function(){

  server <- mangal.env$prod$server
  url <- httr::modify_url(server, path = paste0(mangal.env$base, "/taxa"))
  
  L <- as.numeric(sub('.*/', '', httr::headers(httr::GET(url, config = mangal.env$headers))$`content-range`))
  
  for (i in 1:L) {

    path <- httr::modify_url(mangal.env$prod$server, path = paste0(mangal.env$base, "/taxa/?id=", i ))

    taxon <- as.vector(content(GET(path, config = mangal.env$headers))[[1]]$'original_name')

    if(((str_detect(taxon, "[:digit:]") == TRUE || str_detect(taxon, "[:punct:]") == TRUE) &
         str_detect(taxon, "sp") == TRUE) ||
         str_detect(taxon, "n\\.i\\.") == TRUE ||
         str_detect(taxon, "indet\\.") == TRUE ||
         str_detect(taxon, "sp$") == TRUE){

      taxon <- stringr::word(taxon, start = 1)
    }

    id <- jsonlite::toJSON(data.frame(taxo_id = GET_fkey("taxa_back", "name", taxon)))

    if(id != 0) PUT(url = path, body = substr(id, 2, (nchar(id))-1), config = mangal.env$headers)
  }
}
