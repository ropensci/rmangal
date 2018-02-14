#' @title POST data in the Mangal interactions table
#'
#' @description GET foreign keys needed for the 'interactions' table then POST
#'    the metadata associated. 'attributes', 'environments', 'networks', 'refs'
#'    and 'users' tables must be POST before.
#'
#' @param inter_df A dataframe with three columns: taxon_1, taxon_2 and value
#'
#' @return
#'
#' The status of the injection:
#' 'interactions done' an id has been created for each interactions and the
#' injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom data.table setDT

# Create and inject interactions table ##
POST_interactions <- function(inter_df){

  # Retrive foreign keys
  ## taxon_1 & taxon_2
  inter_df[, "taxon_1"] <- NA
  inter_df[, "taxon_2"] <- NA

  for (i in 1:nrow(inter_df)) {
    try(inter_df[i, "taxon_1"] <- GET_fkey("taxons", "name", inter_df[i,1]))
    try(inter_df[i, "taxon_2"] <- GET_fkey("taxons", "name", inter_df[i,2]))
  }

  inter_df[, "attr_id"]        <- GET_fkey("attributes", "name", attr[[1]])
  inter_df[, "environment_id"] <- GET_fkey("environments", "name", enviro[[1]])
  inter_df[, "network_id"]     <- GET_fkey("networks", "name", networks[[1]])
  inter_df[, "ref_id"]         <- GET_fkey("refs", "doi", refs[[1]])
  inter_df[, "user_id"]        <- GET_fkey("users", "name", users[[1]])

  # Remove unused column
  inter_df <- inter_df[,3:ncol(inter_df)]

  # Add metadata
  inter_df <- cbind(data.table::setDT(inter_df),
                    data.table::setDT(as.data.frame(inter)))

  # inter_df as a json list
  inter_lst <- json_list(as.data.frame(inter_df))

  # Inject to interactions table
  POST_table(inter_lst, "interactions")

 print("interactions done")
}
