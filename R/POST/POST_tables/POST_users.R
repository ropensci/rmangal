#' @title POST data into the Mangal users table
#'
#' @description POST the metadata associated with the users table.
#'
#' @return
#'
#'The status of the injection:
#' 'user already in mangal' means that the environment name already have an id
#' 'user done' an id has been created and the injection is succesfull
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

### This is a test ###
## Create and inject users table ##
POST_users <- function(){

  # Check if the users already exist
  server <- "http://localhost:3000"

  config <- add_headers("Content-type" = "application/json")

  path <- httr::modify_url(server, path = paste0("/api/v0/","users/?name=",users[[1]]))

  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = config))) == 0) {

    # users_df as a json list
    users_lst <- json_list(data.frame(users))

    # Inject to users table
    POST_table(users_lst, "users")

    #Probleme : refuse d'ajouter d'autre champ que "name"

    print("user done")

  } else {

    print("user already in mangal")

  }
}
