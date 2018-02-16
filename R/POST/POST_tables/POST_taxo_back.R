#' @title POST data into the Mangal taxo_back table
#'
#' @description POST the metadata associated to the taxonomic backbone.
#'
#' @return
#'
#' The status of the injection:
#' 'taxo_back done' ids have been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database

## Create and inject taxo_back table ##
POST_taxo_back <- function(){

  # taxon_df as a json list
  taxo_back_lst <- json_list(taxo_back_df)

  # Inject to networks table
  POST_table(taxo_back_lst, "taxo_back")

  print("taxo_back done")
}
