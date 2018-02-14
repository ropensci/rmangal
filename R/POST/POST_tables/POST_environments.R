#' @title POST data into the Mangal environments table
#'
#' @description GET foreign keys needed for the 'environments' table then POST
#'    the metadata associated. 'attributes' and 'refs' tables must be POST
#'    before.
#'
#' @return
#'
#' The status of the injection:
#' 'enviro already in mangal' means that the environment name already have an
#' id
#' 'enviro done' an id has been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers

## Create and inject environments table ##
POST_environments <- function(){

  # Check if the environments already exist
  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  path <- httr::modify_url(server, path = paste0("/api/v0/",
                                               "environments/?name=",
                                               enviro[[1]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = config))) == 0) {

    # Retrive foreign key
    enviro <- c(enviro, attr_id = GET_fkey("attributes", "name", attr[[1]]))
    enviro <- c(enviro, ref_id = GET_fkey("refs", "doi", refs[[1]]))

    # Environments_df as a json list
    environments_lst <- json_list(data.frame(enviro))

    # Inject to environment table
    POST_table(environments_lst, "environments")

    print("enviro done")

  } else {

    print("enviro already in mangal")

  }
}
