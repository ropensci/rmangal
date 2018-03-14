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
#' @importFrom httr add_headers
#' @importFrom httr GET
#'
#' @export

# Create and inject interactions table ##
POST_interactions <- function(inter_df = data, enviro = enviro, attr = attr_inter){

  # Retrive foreign keys
  ## taxon_1 & taxon_2
  inter_df[, "taxon_1"] <- NA
  inter_df[, "taxon_2"] <- NA

  for (i in 1:nrow(inter_df)) {
    try(inter_df[i, "taxon_1"] <- GET_fkey("taxons", c("original_name", "network_id"), c(as.character(inter_df[i, "sp_taxon_1"]), GET_fkey("networks", "name", networks[["name"]]))))
    try(inter_df[i, "taxon_2"] <- GET_fkey("taxons", c("original_name", "network_id"), c(as.character(inter_df[i, "sp_taxon_2"]), GET_fkey("networks", "name", networks[["name"]]))))
  }

  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/attributes/?name=", attr[["name"]], "&unit=", attr[["unit"]])), config = config))) != 0){
    inter_df[, "attr_id"] <- GET_fkey("attributes", c("name", "unit"), c(attr[["name"]], attr[["unit"]]))
  }

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/environments/?name=", enviro[["name"]], "&date=", enviro[["date"]], "&value=", enviro[[value]])), config = config))) != 0){
    inter_df[, "environment_id"] <- GET_fkey("environments", c("name", "date", "value"), c(enviro[["name"]], envrio[["date"]], enviro[["value"]]))
  }

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/users/?name=", users[["name"]])), config = config))) != 0){
    inter_df[, "user_id"]        <- GET_fkey("users", "name", users[["name"]])
  }

  # Remove unused column
  inter_df <- inter_df[,3:ncol(inter_df)]

  print("keys added")

  # attach location to the interaction metadata
  geoloc <- geojsonio::geojson_list(c(inter$lat,inter$lon))$features[[1]]$geometry
  geoloc$crs <- list(type="name",properties=list(name=paste0("EPSG:",inter$srid)))

  inter$localisation <- geoloc

  inter[c("lat","lon","srid")] <- NULL

  # Set list of interaction + metadata
  inter_lst <- list()

  for (i in 1:nrow(inter_df)) {

    inter_lst[[i]] <- as.list(inter_df[i, ])

    inter_lst[[i]] <- c(inter_lst[[i]], inter)

    # to JSON
    inter_lst[[i]] <- toJSON(inter_lst[[i]], auto_unbox = TRUE, digits = 12)
  }

  print("metadata added")

  # Inject to interactions table
  POST_table(inter_lst, "interactions")

  rm(inter_lst)

  print("interactions done")
}
