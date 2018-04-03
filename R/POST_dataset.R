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
POST_dataset <- function(){

  # Check if the datasets already exist
  server <- mangal.env$prod$server

  path <- httr::modify_url(server, path = paste0(mangal.env$base, "/dataset/?name=",
                                         dataset[[1]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

    # Retrive foreign key
    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/user/?name=", user[["name"]])), config = mangal.env$headers))) != 0){
      dataset <- c(dataset, user_id = GET_fkey("user","name", user[["name"]]))
    }

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/ref/?author=", ref[["author"]], "&year=", ref[["year"]])), config = mangal.env$headers))) != 0){
    dataset <- c(dataset, ref_id = GET_fkey("ref", c("author", "year"), c(ref[["author"]], ref[["year"]])))
    }

    # Datasets_df as a json list
    dataset_lst <- json_list(data.frame(dataset))

    # Inject  to datasets table
    POST_table(dataset_lst, "dataset")

    print("dataset done")

  } else {

    print("dataset already in mangal")

  }
}
