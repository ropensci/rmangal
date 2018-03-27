#' @title Update taxon_id in the table taxons
#'
#' @description GET the foreign key 'taxon_id' from the table taxo_backs and update it in the table taxons
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom RPostgreSQL dbSendQuery
#' @importFrom RPostgreSQL dbConnect
#' @importFrom httr add_headers
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom jsonlite toJSON
#' @importFrom stringr word

## Update taxon_id
PUT_taxon_id <- function(){

  con <- RPostgreSQL::dbConnect(PostgreSQL(),
                                host = "poisotlab.biol.umontreal.ca",
                                port = 5432,
                                dbname = "mangal_dev",
                                password = "3cho^",
                                user = "mangal")

  L <- "SELECT count(*)
          FROM taxons;"

  L <- RPostgreSQL::dbGetQuery(con, L)[1, 1]

  for (i in 1:L) {

    path <- httr::modify_url(mangal.env$prod$server, path = paste0(mangal.env$base, "/taxon/", i ))

    taxon <- as.vector(content(GET(path))[[2]])

    if(((str_detect(taxon, "[:digit:]") == TRUE || str_detect(taxon, "[:punct:]") == TRUE) &
         str_detect(taxon, "sp") == TRUE) ||
         str_detect(taxon, "n\\.i\\.") == TRUE ||
         str_detect(taxon, "sp$") == TRUE){

      taxon <- stringr::word(taxon, start = 1)
    }

    id <- jsonlite::toJSON(data.frame(taxo_id = GET_fkey("taxo_backs", "name", taxon)))

    if(id != 0) PUT(url = path, body = substr(id, 2, (nchar(id))-1), config = mangal.env$headers)
  }
}
