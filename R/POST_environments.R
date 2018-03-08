#' @title POST data into the Mangal environments table
#'
#' @description GET foreign keys needed for the 'environments' table then POST
#'    the metadata associated. 'attributes' and 'refs' tables must be POST
#'    before.
#'
#' @return
#'
#' The status of the injection:
#' 'enviro already in mangal' means that the environment name already have an
#' id
#' 'enviro done' an id has been created and the injection is succesfull
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

## Create and inject environments table ##
POST_environments <- function(enviro = enviro, attr = attr){

  # Check if the environments already exist
  server <- "http://localhost:3000"

  config <- httr::add_headers("Content-type" = "application/json")

  path <- httr::modify_url(server, path = paste0("/api/v0/",
                                               "environments/?name=",
                                               enviro[[1]]))
  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = config))) == 0) {

    # Retrive foreign key
    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/attributes/?name=", attr[["name"]])), config = config))) != 0){
      enviro <- c(enviro, attr_id = GET_fkey("attributes", "name", attr[["name"]]))
    }

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, "/api/v0/refs/?data_url=", refs[["data_url"]])), config = config))) != 0){
    enviro <- c(enviro, ref_id = GET_fkey("refs", "data_url", refs[["data_url"]]))
    }

    # attach location to the environment
    geoloc <- geojsonio::geojson_list(c(enviro$lat,enviro$lon))$features[[1]]$geometry
    geoloc$crs <- list(type="name",properties=list(name=paste0("EPSG:",enviro$srid)))
    enviro$localisation <- geoloc

    # enviro as a json list
    enviro[c("lat","lon","srid")] <- NULL
    environments_lst <- json_list(enviro)

    # Inject to environment table
    POST_table(environments_lst, "environments")

    print("enviro done")

  } else {

    print("enviro already in mangal")

  }
}
