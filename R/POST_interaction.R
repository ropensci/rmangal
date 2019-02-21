#' @title POST data in the Mangal interactions table
#'
#' @description GET foreign keys needed for the 'interactions' table then POST
#'    the metadata associated. 'attributes', 'environments', 'networks', 'refs'
#'    and 'users' tables must be POST before.
#'
#' @param inter_df A dataframe with three columns:\cr
#' 'taxon_1' and 'taxon_2': names of the taxa as they appear in the taxa table\cr
#' 'value': value of the measured interaction\cr
#' 
#' @param inter A list of the interaction's metadata; must have these levels:\cr
#' 'taxon_1_level' and 'taxon_2_level': taxonomic level of the taxa ('taxon', 'population' or 'individual')\cr
#' 'date': YYYY-MM-DD\cr
#' 'direction': direction of the interaction ('directed', 'undirected' of 'unknown')\cr
#' 'type': type of biological interaction ('competition', 'amensalism', 'neutralism', 'commensalism', 'mutualism', 'parasitism', 'predation', 'herbivory', 'symbiosis', 'scavenger', 'unknown')\cr
#' 'method': how the interaction was recorded\cr
#' 'value': value of the interaction
#' 'lat', 'lon' and 'srid': spacial coordinates and spacial reference id (SRID) of the interaction\cr
#' 'public': boolean\cr
#' 
#' @param enviro A list of the environement's metadata; must have the levels 'name', 'date' and 'value'
#' @param attr A list of the interaction's attribute; must have the levels 'name' and 'unit'
#' @param users A list of the user's metadata; must have the level 'name'
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
POST_interaction <- function(inter_df, inter, enviro = NA, attr = NULL, users, network){

  # Put attribute in lowercase
  attr[["name"]] <- tolower(attr[["name"]])
  if(attr[["unit"]] != "NA") attr[["unit"]] <- tolower(attr[["unit"]])


  # Retrive foreign keys
  ## node_from & node_to
  inter_df[, "node_from"] <- NA
  inter_df[, "node_to"] <- NA

  for (i in 1:nrow(inter_df)) {
    try(inter_df[i, "node_from"] <- GET_fkey("node", c("original_name", "network_id"), c(as.character(inter_df[i, "sp_taxon_1"]), GET_fkey("network", "name", tolower(network[["name"]])))))
    try(inter_df[i, "node_to"] <- GET_fkey("node", c("original_name", "network_id"), c(as.character(inter_df[i, "sp_taxon_2"]), GET_fkey("network", "name", tolower(network[["name"]])))))
  }

  server <- mangal.env$prod$server

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/attribute?name=", tolower(attr[["name"]]), "&unit=", attr[["unit"]])), config = mangal.env$headers))) != 0){
    inter_df[, "attr_id"] <- GET_fkey("attribute", c("name", "unit"), c(tolower(attr[["name"]]), attr[["unit"]]))
  }

  if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/environment?name=", enviro[["name"]], "&date=", enviro[["date"]], "&value=", enviro[["value"]])), config = mangal.env$headers))) != 0){
    inter_df[, "environment_id"] <- GET_fkey("environment", c("name", "date", "value"), c(enviro[["name"]], enviro[["date"]], enviro[["value"]]))
  }

  # Remove unused column
  inter_df <- inter_df[,3:ncol(inter_df)]

  print("keys added")

  # attach location to the interaction metadata
  coordinates <- list()
  for(i in 1:length(inter$lat)) { coordinates <- c(coordinates, list(c(inter$lat[i], inter$lon[i])))}
  
  if(length(inter$lat) > 1 & length(inter$lon) > 1){
    geometry <- "polygon"
    coordinates <- c(coordinates, list(c(inter$lat[1], inter$lon[1])))
    
    } else { geometry <- "point"
  }
  
  geoloc <- geojsonio::geojson_list(coordinates, geometry = geometry)$features[[1]]$geometry
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
