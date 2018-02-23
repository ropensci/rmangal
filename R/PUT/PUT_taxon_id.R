#' @title Update taxon_id in the table taxons
#'
#' @description GET the foreign key 'taxon_id' from the table taxo_backs and update it in the table taxons
#'
#' @return
#'
#'
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom RPostgreSQL dbSendQuery

## Update taxon_id
PUT_taxon_id <- function(){

  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  con <- dbConnect(PostgreSQL(),
                   host = "localhost",
                   port = 5432,
                   dbname = "mangal_dev",
                   password = "postgres",
                   user = "postgres")

  L <- "SELECT count(*)
          FROM taxons;"

  L <- dbGetQuery(con, L)

  for (i in 1:L[1,1]) {



    ============= Rendu ici =================



    path <- httr::modify_url(server, path = gsub(" ", "%20", paste0("/api/v0/taxon/", i )))

    taxon <- content(GET(path))

    PUT(url, body = GET_fkey("Du taxon i vers la table taxo_back"), config = config)
  }
}
