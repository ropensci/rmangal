#' @title POST data into the Mangal networks table
#'
#' @description GET foreign keys needed for the 'networks' table then POST the
#'  metadata associated. 'environments', 'users', 'datasets' and 'refs' tables
#'  must be POST before.
#'
#' @param networks_lst A list with the network metadata
#'
#' @return
#'
#' The status of the injection:
#' 'network already in mangal' means that the environment name already have an
#' id
#' 'network done' an id has been created and the injection is succesfull
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

## Create and inject networks table ##
POST_networks <- function(networks_lst, enviro = enviro){

  # Check if the networks already exist
  server <- mangal.env$prod$server

  path <- httr::modify_url(server, path = paste0(mangal.env$base, "/networks/?name=",
                                          networks_lst[["name"]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

    # Retrive foreign key
    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/datasets/?name=", datasets[["name"]])), config = mangal.env$headers))) != 0){
      networks_lst <- c(networks_lst, dataset_id = GET_fkey("datasets", "name", datasets[["name"]]))
    }

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/environments/?name=", enviro[["name"]], "&date=", enviro[["date"]], "&value=", enviro[["value"]])), config = mangal.env$headers))) != 0){
      networks_lst <- c(networks_lst, environment_id = GET_fkey("environments", c("name", "date", "value"), c(enviro[["name"]], enviro[["date"]], enviro[["value"]])))
    }

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/users/?name=", users[["name"]])), config = mangal.env$headers))) != 0){
      networks_lst <- c(networks_lst, user_id = GET_fkey("users", "name", users[["name"]]))
    }

    # attach location to the network
    geoloc <- geojsonio::geojson_list(c(networks_lst$lat,networks_lst$lon))$features[[1]]$geometry
    geoloc$crs <- list(type="name",properties=list(name=paste0("EPSG:",networks_lst$srid)))
    networks_lst$localisation <- geoloc

    # networks_df as a json list
    networks_lst[c("lat","lon","srid")] <- NULL
    networks_lst <- json_list(networks_lst)

    # Inject to networks table
    POST_table(networks_lst, "networks")

    print("network done")

  } else {

    print("network already in mangal")

  }
}
