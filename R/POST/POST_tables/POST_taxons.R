#' @title POST data into the Mangal taxons table
#'
#' @description GET foreign keys needed for the 'taxons' table then POST
#'    the metadata associated.
#'
#' @return
#'
#' The status of the injection:
#' 'taxon done' ids have been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database

## Create and inject taxons table ##
POST_taxons <- function(){

  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  # Get taxo_id from taxo_back table
  for (i in 1:nrow(taxons_df)) {

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/taxo_backs/?name=",
                                                               taxons_df[i, "name_clear"])), config = config))) == 0){

      print(paste0(taxons_df[i, "original_name"], " is not in taxo_backbone, entry was skip"))

      } else {

        taxons_df[i, "id_sp"] <- GET_fkey("taxo_backs", "name", taxons_df[i, "name_clear"])

      }

    }

  taxons_df[, "network_id"] <- GET_fkey("networks", "name", networks[[1]])

  # taxon_df as a json list
  taxons_lst <- json_list(taxons_df)

  # Inject to networks table
  POST_table(taxons_lst, "taxons")

  print("taxons done")
}
