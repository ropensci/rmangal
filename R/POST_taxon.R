#' @title POST data into the Mangal taxons table
#'
#' @description GET foreign keys needed for the 'taxons' table then POST
#'    the metadata associated.
#'    
#' @param taxa_df A dataframe of two columns:\cr
#' 'original_name': name of the taxa as found in the publication\cr
#' 'name_clear': clean taxonomy, name of the taxa without numbers, punctuations or 'sp'
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
POST_taxon <- function(taxa_df = taxa_df){

  server <- mangal.env$prod$server

  # Get taxo_id from taxo_back table
  for (i in 1:nrow(taxa_df)) {

    if (length(httr::content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/taxa_back/?name=", taxa_df[i, "name_clear"])), config = mangal.env$headers))) == 0){

      print(paste0(taxa_df[i, "original_name"], " is not in taxa_backbone, no taxo_id"))

      } else {

        taxa_df[i, "taxo_id"] <- GET_fkey("taxa_back", "name", taxa_df[i, "name_clear"])

      }

    }

  taxa_df[, "network_id"] <- GET_fkey("network", "name", tolower(network[["name"]]))

  print("key added")

  # taxa_df as a json list
  taxon_lst <- json_list(taxa_df)

  # Inject to networks table
  POST_table(taxon_lst, "taxa")

  print("taxon done")
}
