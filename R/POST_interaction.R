#' @title POST data in the Mangal interactions table
#'
#' @description GET foreign keys needed for the 'interactions' table then POST
#'    the metadata associated. 'attributes', 'environments', 'networks', 'refs'
#'    and 'users' tables must be POST before.
#'
#' @param inter_df A dataframe with three columns: taxon_1, taxon_2 and value
#' @param enviro A list containing the metadata of the environment; must have levels: name, date, value
#' @param attr A list containing the metadate of the attribute; must have levels: name, unit
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
POST_interaction <- function(inter_df = data, enviro = NA, attr = NULL){

  # Put attribute in lowercase
  attr[["name"]] <- tolower(attr[["name"]])
  if(attr[["value"]] != "NA") attr[["value"]] <- tolower(attr[["value"]])


  # Retrive foreign keys
  ## taxon_1 & taxon_2
  inter_df[, "taxon_1"] <- NA
  inter_df[, "taxon_2"] <- NA

  for (i in 1:nrow(inter_df)) {
    try(inter_df[i, "taxon_1"] <- GET_fkey("taxa", c("original_name", "network_id"), c(as.character(inter_df[i, "sp_taxon_1"]), GET_fkey("network", "name", network[["name"]]))))
    try(inter_df[i, "taxon_2"] <- GET_fkey("taxa", c("original_name", "network_id"), c(as.character(inter_df[i, "sp_taxon_2"]), GET_fkey("network", "name", network[["name"]]))))
  }

  server <- mangal.env$prod$server

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/attribute/?name=", attr[["name"]], "&unit=", attr[["unit"]])), config = mangal.env$headers))) != 0){
    inter_df[, "attr_id"] <- GET_fkey("attribute", c("name", "unit"), c(attr[["name"]], attr[["unit"]]))
  }

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/environment/?name=", enviro[["name"]], "&date=", enviro[["date"]], "&value=", enviro[["value"]])), config = mangal.env$headers))) != 0){
    inter_df[, "environment_id"] <- GET_fkey("environment", c("name", "date", "value"), c(enviro[["name"]], enviro[["date"]], enviro[["value"]]))
  }

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/users/?name=", users[["name"]])), config = mangal.env$headers))) != 0){
    inter_df[, "user_id"] <- GET_fkey("users", "name", users[["name"]])
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
  POST_table(inter_lst, "interaction")

  rm(inter_lst)

  print("interaction done")
}
