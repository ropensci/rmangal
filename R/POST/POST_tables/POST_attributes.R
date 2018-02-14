#' @title POST data into the Mangal attributes table
#'
#' @description POST the metadata associated whit the attributes table
#'
#' @return
#'
#' The status of the injection:
#' 'attr already in mangal' means that the attribute name already have an id
#' 'attr done' an id has been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers

## Create and inject attributes table ##
POST_attributes <- function(){

  # Check if the attribute already exist
  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  path <- httr::modify_url(server, path = paste0("/api/v0/",
                                               "attributes/?name=",attr[[1]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = config))) == 0) {

    # Attibutes_df as a json list
    attributes_lst <- json_list(data.frame(attr))

    # Inject to attributes table
    POST_table(attributes_lst, "attributes")

    print("attr done")

  } else {

    print("attr already in mangal")
 }
}
