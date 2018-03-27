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
#'
#' @importFrom httr GET
#' @importFrom httr add_headers
#' @importFrom httr content
#'
#' @export

## Create and inject taxons table ##
POST_taxons <- function(taxons_df = taxons_df){

  server <- mangal.env$prod$server

  # Get taxo_id from taxo_back table
  for (i in 1:nrow(taxons_df)) {

    if (length(httr::content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/taxo_backs/?name=", taxons_df[i, "name_clear"])), config = mangal.env$headers))) == 0){

      print(paste0(taxons_df[i, "original_name"], " is not in taxo_backbone, no taxo_id"))

      } else {

        taxons_df[i, "taxo_id"] <- GET_fkey("taxo_backs", "name", taxons_df[i, "name_clear"])

      }

    }

  taxons_df[, "network_id"] <- GET_fkey("networks", "name", networks[["name"]])

  print("key added")

  # taxon_df as a json list
  taxons_lst <- json_list(taxons_df)

  # Inject to networks table
  POST_table(taxons_lst, "taxons")

  print("taxons done")
}
