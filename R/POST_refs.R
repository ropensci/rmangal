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
#'
#' @export

## Create and inject refs table ##
POST_refs <- function(){

  # Check if the refs already exist
  server <- "http://localhost:3000"

  config <- add_headers("Content-type" = "application/json")

  path <- modify_url(server, path = paste0("/api/v0/refs/?author=",refs[["author"]], "&years=", refs[["years"]]))

  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

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
}
