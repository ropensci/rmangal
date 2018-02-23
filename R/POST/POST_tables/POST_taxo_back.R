#' @title POST data into the Mangal taxo_back table
#'
#' @description POST the metadata associated to the taxonomic backbone.
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

## Create and inject taxo_back table ##
POST_taxo_back <- function(){

  # taxon_df as a json list
  taxo_back_lst <- json_list(taxo_back_df)

  # Is retreived content == 0 -> in this case inject taxo_back
  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  for(i in 1:length(taxo_back_lst)){

    path <- httr::modify_url(server, path = gsub(" ", "%20", paste0("/api/v0/","taxo_backs/?name=",
                                                                    taxo_back_df[i, "name"])))

    # Is retreived content == 0 -> in this case inject data
    if (length(content(httr::GET(url = path, config = config))) == 0) {

      # Inject to networks table
      POST_line(taxo_back_lst[[i]], "taxo_backs")

    } else {

      print(paste0(taxo_back_df[i, "name"], " is already in Mangal, entry was skip"))

    }

  }

  print("taxo_back done")
}
