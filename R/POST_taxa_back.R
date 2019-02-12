#' @title POST data into the Mangal taxo_back table
#'
#' @description POST the metadata associated to the taxonomic backbone.
#'
#' @param taxa_back A dataframe with five columns: \cr
#' 'name': clean taxonomy, name of the taxa without numbers or 'sp'\cr
#' 'bold': BOLD taxa id\cr
#' 'eol': Encyclopedia of life taxa id\cr
#' 'tsn': ITIS taxa id\cr
#' 'ncbi': NCBI taxa id\cr
#'
#' @return
#'
#' The status of the injection:
#' 'taxo_back done' ids have been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers
#' @importFrom httr content
#'
#' @export

## Create and inject taxo_back table ##
POST_taxa_back <- function(taxa_back = taxa_back){

  # taxon_df as a json list
  taxa_back_lst <- json_list(taxa_back)

  # Is retreived content == 0 -> in this case inject taxo_back
  server <- mangal.env$prod$server

  for(i in 1:length(taxa_back_lst)){

    path <- httr::modify_url(server, path = gsub(" ", "%20", paste0(mangal.env$base, "/taxonomy/?name=",
                                                                    taxa_back[i, "name"])))

    # Is retreived content == 0 -> in this case inject data
    if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

      # Inject to networks table
      POST_line(taxa_back_lst[[i]], "taxa_back")

    } else {

      print(paste0(taxa_back_df[i, "name"], " is already in Mangal, entry was skip"))

    }

  }

  print("taxa_back done")
}
