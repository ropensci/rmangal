#' @title POST data into the Mangal attributes table
#'
#' @description POST the metadata associated whit the attributes table
#'
#' @param attr A list of the attribute's metadata; must have four levels:\cr
#' 'name': name of the attribute\cr
#' 'table_owner': 'interaction', 'trait' or 'environment'\cr
#' 'description': description of the attribute; how is it mesured\cr
#' 'unit': what is the unit of mesure? ("NA" if none)\cr
#'
#' @return
#'
#' The status of the injection: \cr
#' 'attr already in mangal' means that the attribute name already have an id \cr
#' 'attr done' an id has been created and the injection is succesfull \cr
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
POST_attribute <- function(attr){

  # Put attribute in lowercase
  attr[["name"]] <- tolower(attr[["name"]])
  if(attr[["unit"]] != "NA") attr[["unit"]] <- tolower(attr[["unit"]])

  # Check if the attribute already exist
  server <- mangal.env$prod$server

  path <- httr::modify_url(server, path = paste0(mangal.env$base, "/attribute?name=",attr[["name"]],
                                                 "&unit=", attr[["unit"]]))

   # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

    # Attibutes_df as a json list
    attribute_lst <- json_list(as.data.frame(attr, stringAsFactors = F))

    # Inject to attributes table
    POST_table(attribute_lst, "attribute")

    print(paste0(attr$name, " attribute done"))

  } else {

    print("attribute already in mangal")
 }
}
