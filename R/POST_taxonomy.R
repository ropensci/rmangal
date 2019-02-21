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
POST_taxonomy <- function(taxo){

  # taxon_df as a json list
  taxo_lst <- json_list(taxo)

  # Is retreived content == 0 -> in this case inject taxo_back
  server <- mangal.env$prod$server

  for(i in 1:length(taxo_lst)){

    path <- httr::modify_url(server, path = gsub(" ", "%20", paste0(mangal.env$base, "/taxonomy?name=",
                                                                    taxo[i, "name"])))

    # Is retreived content == 0 -> in this case inject data
    if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

      # Inject to networks table
      POST_line(taxo_lst[[i]], "taxonomy")

    } else {

      print(paste0(taxo[i, "name"], " is already in Mangal, entry was skip"))

    }

  }

  print("taxonomy done")
}
