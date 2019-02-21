#' @title POST data into the Mangal refs table
#'
#' @description POST the metadata associated with the ref table.
#' 
#' @param ref A list of the reference's metadata; must have these levels:\cr
#' 'doi': DOI of the attached publication\cr
#' 'jstor': JSTOR of the attached publication\cr
#' 'pmid': PMID of the attached publication\cr
#' 'paper_url': URL of the attached publication\cr
#' 'data_url': URL of the attached data\cr
#' 'author': first author name\cr
#' 'year': year of publication\cr
#' 'bibtex': BibTex of the attached publication\cr
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
POST_ref <- function(ref = ref){

  # Put attribute in lowercase
  ref[["author"]] <- tolower(ref[["author"]])

  # Check if the refs already exist
  server <- mangal.env$prod$server

<<<<<<< HEAD
  path <- modify_url(server, path = paste0(mangal.env$base, "/reference?author=",ref[["author"]], "&year=", ref[["year"]]))
=======
  path <- modify_url(server, path = paste0(mangal.env$base, "/reference/?author=",ref[["author"]], "&year=", ref[["year"]]))
>>>>>>> 186be47f9a5cc51999a6c291ab6121cafe79a18d

  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(GET(url = path, config = mangal.env$headers))) == 0) {

    # Refs_df as a json list
    refs_lst <- json_list(data.frame(ref, stringsAsFactors = F))

    # Inject to refs table
    POST_table(refs_lst, "reference")

    print("ref done")

  } else {

    print("ref already in mangal")

  }
}
