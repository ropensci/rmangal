#' @title POST data into the Mangal refs table
#'
#' @description POST the metadata associated with the ref table.
#'
#' @return
#'
#' The status of the injection:
#' 'ref already in mangal' means that the ref name already have an id
#' 'ref done' an id has been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers

## Create and inject refs table ##

# Check if the refs already exist
server <- "http://localhost:3000"

config <- add_headers("Content-type" = "application/json")

path <- modify_url(server, path = paste0("/api/v0/","refs/?doi=",refs[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = config))) == 0) {

  # Refs_df as a json list
  refs_lst <- json_list(data.frame(refs))

  # Inject to refs table
  POST_table(refs_lst, "refs")

  print("ref done")

} else {

  print("ref already in mangal")

}
