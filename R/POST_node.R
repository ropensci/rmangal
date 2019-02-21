#' @title POST data into the Mangal taxons table
#'
#' @description GET foreign keys needed for the 'taxons' table then POST
#'    the metadata associated.
#'    
#' @param node_df A dataframe of two columns:\cr
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
POST_node <- function(node_df, network){

  server <- mangal.env$prod$server

  # Get taxo_id from taxo_back table
  for (i in 1:nrow(node_df)) {

<<<<<<< HEAD:R/POST_node.R
    if (length(httr::content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/taxonomy?name=", node_df[i, "name_clear"])), config = mangal.env$headers))) == 0){
=======
    if (length(httr::content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/taxonomy/?name=", taxa_df[i, "name_clear"])), config = mangal.env$headers))) == 0){
>>>>>>> 186be47f9a5cc51999a6c291ab6121cafe79a18d:R/POST_taxon.R

      print(paste0(node_df[i, "original_name"], " is not in taxonomy, no taxo_id"))

      } else {

<<<<<<< HEAD:R/POST_node.R
        node_df[i, "taxonomy_id"] <- GET_fkey("taxonomy", "name", node_df[i, "name_clear"])
=======
        taxa_df[i, "taxo_id"] <- GET_fkey("taxonomy", "name", taxa_df[i, "name_clear"])
>>>>>>> 186be47f9a5cc51999a6c291ab6121cafe79a18d:R/POST_taxon.R

      }

    }

  node_df[, "network_id"] <- GET_fkey("network", "name", tolower(network[["name"]]))
  
  print("key added")

  # node_df as a json list
  node_lst <- json_list(node_df)

  # Inject to networks table
  POST_table(taxon_lst, "node")

  print("taxon done")
}
