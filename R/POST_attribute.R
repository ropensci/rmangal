#' @title POST data into the Mangal attributes table
#'
#' @description POST the metadata associated whit the attributes table
#'
#' @param attr A list of four levels: name, table_owner, description and unit
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
#'
#' @export

## Create and inject attributes table ##
POST_attribute <- function(data){

  # Put attribute in lowercase
  data[["name"]] <- tolower(data[["name"]])
  if(data[["value"]] != "NA") data[["value"]] <- tolower(data[["value"]])

  # Check if the attribute already exist
  server <- mangal.env$prod$server

  path <- httr::modify_url(server, path = paste0(mangal.env$base, "/attribute/?name=",data[["name"]],
                                                 "&unit=", data[["unit"]]))

   # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

    # Attibutes_df as a json list
    attribute_lst <- json_list(as.data.frame(data))

    # Inject to attributes table
    POST_table(attribute_lst, "attribute")

    print(paste0(data$name, " attribute done"))

  } else {

    print("attribute already in mangal")
 }
}
