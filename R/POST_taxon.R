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
POST_taxon <- function(taxon_df = taxon_df){

  server <- mangal.env$prod$server

  # Get taxo_id from taxo_back table
  for (i in 1:nrow(taxon_df)) {

    if (length(httr::content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/taxa_back/?name=", taxon_df[i, "name_clear"])), config = mangal.env$headers))) == 0){

      print(paste0(taxon_df[i, "original_name"], " is not in taxa_backbone, no taxo_id"))

      } else {

        taxon_df[i, "taxo_id"] <- GET_fkey("taxa_back", "name", taxon_df[i, "name_clear"])

      }

    }

  taxon_df[, "network_id"] <- GET_fkey("network", "name", tolower(network[["name"]]))

  print("key added")

  # taxon_df as a json list
  taxon_lst <- json_list(taxon_df)

  # Inject to networks table
  POST_table(taxon_lst, "taxa")

  print("taxon done")
}
