#' @title POST data into the Mangal traits table
#'
#' @description GET foreign keys needed for the 'traits' table then POST
#'    the metadata associated. 'attributes' and 'refs' tables must be POST
#'    before.
#'
#' @return
#'
#' The status of the injection:
#' 'trait already in mangal' means that the environment name already have an
#' id
#' 'trait done' an id has been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers

## Create and inject traits table ##
POST_traits <- function(){

  # Check if the traits already exist
  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  path <- httr::modify_url(server, path = paste0("/api/v0/","traits/?name=",
                                               traits[[1]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = config))) == 0) {

    # Retrive foreign key
    traits <- c(traits, attr_id = GET_fkey("attributes", "name", attr[[1]]))
    traits <- c(traits, ref_id = GET_fkey("refs", "doi", refs[[1]]))

    # traits_df as a json list
    traits_lst <- json_list(data.frame(traits))

    # Inject to traits table
    POST_table(traits_lst, "traits")

    print("trait done")

  } else {

    print("trait already in mangal")

  }
}
