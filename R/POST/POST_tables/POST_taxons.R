#' @title POST data into the Mangal taxons table
#'
#' @description GET foreign keys needed for the 'taxons' table then POST
#'    the metadata associated. 'traits' table must be POST before.
#'
#' @return
#'
#' The status of the injection:
#' 'taxon done' ids have been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database

## Create and inject taxons table ##
POST_taxons <- function(){

  # Retrive foreign key
  ## trait_id
  taxons_df[,6] <- GET_fkey("traits", "name", traits[[1]])

  # taxon_df as a json list
  taxons_lst <- json_list(taxons_df)

  # Inject to networks table
  POST_table(taxons_lst, "taxons")

  print("taxon done")
}
