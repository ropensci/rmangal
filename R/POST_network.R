#' @title POST data into the Mangal network table
#'
#' @description GET foreign keys needed for the 'network' table then POST the
#'  metadata associated. 'environments', 'users', 'datasets' and 'refs' tables
#'  must be POST before.
#'
#' @param network_lst A list of the network's metadata; must have these levels:\cr
#' 'name': name of the network\cr
#' 'date': YYYY-MM-DD\cr
#' 'lat', 'lon' and 'srid': spatial coordinates and spatial reference id (SRID)\cr
#' 'description': description of the network collected\cr
#' 'public': boolean\cr
#' 'all_interactions': boolean\cr
#' 
#' @param enviro A list of the environement's metadata; must have the levels 'name', 'date' and 'value'
#' @param dataset A list of the dataset's metadata; must have the level 'name'
#' @param users A list of the user's metadata; must have the level 'name'
#'
#' @return
#'
#' The status of the injection:\cr
#' 'network already in mangal' means that the environment name already have an id\cr
#' 'network done' an id has been created and the injection is succesfull\cr
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers
#' @importFrom jsonlite toJSON
#' @importFrom geojsonio geojson_list
#'
#' @export

## Create and inject network table ##
POST_network <- function(network_lst, enviro = enviro, dataset = dataset, users = users){

  # Put attribute in lowercase
  network_lst[["name"]] <- tolower(network_lst[["name"]])

  # Check if the network already exist
  server <- mangal.env$prod$server

  path <- httr::modify_url(server, path = paste0(mangal.env$base, "/network/?name=",
                                          network_lst[["name"]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

    # Retrive foreign key
    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/dataset/?name=", tolower(dataset[["name"]]))), config = mangal.env$headers))) != 0){
      network_lst <- c(network_lst, dataset_id = GET_fkey("dataset", "name", tolower(dataset[["name"]])))
    }

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/environment/?name=", tolower(enviro[["name"]]), "&date=", enviro[["date"]], "&value=", enviro[["value"]])), config = mangal.env$headers))) != 0){
      network_lst <- c(network_lst, environment_id = GET_fkey("environment", c("name", "date", "value"), c(tolower(enviro[["name"]]), enviro[["date"]], enviro[["value"]])))
    }

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/users/?name=", users[["name"]])), config = mangal.env$headers))) != 0){
      network_lst <- c(network_lst, user_id = GET_fkey("users", "name", users[["name"]]))
    }

    # attach location to the network
    geoloc <- geojsonio::geojson_list(c(network_lst$lat,network_lst$lon))$features[[1]]$geometry
    geoloc$crs <- list(type="name",properties=list(name=paste0("EPSG:",network_lst$srid)))
    network_lst$localisation <- geoloc

    # network_df as a json list
    network_lst[c("lat","lon","srid")] <- NULL
    network_lst <- json_list(network_lst)

    # Inject to network table
    POST_table(network_lst, "network")

    print("network done")

  } else {

    print("network already in mangal")

  }
}
