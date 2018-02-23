#' @title POST data into the Mangal traits table
#'
#' @description GET foreign keys needed for the 'traits' table then POST
#'    the metadata associated. 'attributes' and 'refs' tables must be POST
#'    before.
#'
#' @param traits_df A dataframe with three columns: taxon, name (of the trait) and value
#'
#' @return
#'
#' The status of the injection:
#' 'trait already in mangal' means that the environment name already have an id
#' 'trait done' an id has been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers

## Create and inject traits table ##
POST_traits <- function(traits_df){

  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  # Retreive fkey for ref_id, taxon_id and attr_id
  traits_df[, "ref_id"] <- GET_fkey("refs", "doi", refs[[1]])

  traits_df[, "taxon_id"] <- NA
  traits_df[, "attr_id"] <- NA

  for (i in 1:nrow(traits_df)) {

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/taxons/?original_name=",
                                                             traits_df[i, "taxon"])), config = config))) == 0){

      print(paste0(traits_df[i, "taxon"], " is not in taxons table, entry was skip"))

      } else {

      traits_df[i, "taxon_id"] <- GET_fkey("taxons", "original_name", as.character(traits_df[i, "taxon"]))

      }
  }

  for (i in 1:nrow(traits_df)) {

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/attributes/?name=",
                                                              traits_df[i, "name"])), config = config))) == 0){

      print(paste0(traits_df[i, "name"], " is not in attributes table, entry was skip"))

      } else {

      traits_df[i, "attr_id"] <- GET_fkey("attributes", "name", as.character(traits_df[i, "name"]))

    }

  }

  # Remove taxon column
  traits_df <- traits_df[, -1]

  # Add metadata
  traits_df <- cbind(data.table::setDT(traits_df),
                    data.table::setDT(as.data.frame(traits)))

  # traits_df as a json list
  traits_lst <- json_list(data.frame(traits_df))

  # Inject to traits table
  POST_table(traits_lst, "traits")

  print("trait done")

}

