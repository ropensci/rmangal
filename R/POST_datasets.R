#' @title POST data into the Mangal datasets table
#'
#' @description GET foreign keys needed for the 'datasets' table then POST
#'    the metadata associated. 'users' and 'refs' tables must be POST
#'    before.
#'
#' @return
#'
#' The status of the injection:
#' 'dataset' already in mangal' means that the dataset name already have an id
#' 'dataset done' an id has been created and the injection is succesfull
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

## Create and inject datasets table ##
POST_datasets <- function(){

  # Check if the datasets already exist
  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  path <- httr::modify_url(server, path = paste0("/api/v0/","datasets/?name=",
                                         datasets[[1]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = config))) == 0) {

    # Retrive foreign key
    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/users/?name=", users[[1]])), config = config))) != 0){
      datasets <- c(datasets, user_id = GET_fkey("users","name", users[[1]]))
    }

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/refs/?bibtex=", refs[["bibtex"]])), config = config))) != 0){
    datasets <- c(datasets, ref_id = GET_fkey("refs", "bibtex", refs[["bibtex"]]))
    }

    # Datasets_df as a json list
    datasets_lst <- json_list(data.frame(datasets))

    # Inject  to datasets table
    POST_table(datasets_lst, "datasets")

    print("datasets done")

  } else {

    print("dataset already in mangal")

  }
}
