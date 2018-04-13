#' @title POST data into the Mangal environments table
#'
#' @description GET foreign keys needed for the 'environments' table then POST
#'    the metadata associated. 'attributes' and 'refs' tables must be POST
#'    before.
#'
#' @return
#'
#' The status of the injection:
#' 'enviro already in mangal' means that the environment name already have an id
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
POST_environment <- function(enviro = enviro, attr = attr){

  # Put attribute in lowercase
  attr[["name"]] <- tolower(attr[["name"]])
  if(attr[["value"]] != "NA") attr[["value"]] <- tolower(attr[["value"]])

  enviro[["name"]] <- tolower(envrio[["name"]])

  # Check if the environments already exist
  server <- mangal.env$prod$server

  path <- httr::modify_url(server, path = paste0(mangal.env$base, "/environment/?name=", enviro[["name"]], "&date=", enviro[["date"]], "&value=", enviro[["value"]]))

  # Change space in url by "_"
  path <- gsub(" ", "%20", path)

  # Is retreived content == 0 -> in this case inject data
  if (length(content(httr::GET(url = path, config = mangal.env$headers))) == 0) {

    # Retrive foreign key
    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/attribute/?name=", attr[["name"]], "&unit=", attr[["unit"]])), config = mangal.env$headers))) != 0){
      enviro <- c(enviro, attr_id = GET_fkey("attribute", c("name", "unit"), c(attr[["name"]], attr[["unit"]])))
    }

    # attach location to the environment
    geoloc <- geojsonio::geojson_list(c(enviro$lat,enviro$lon))$features[[1]]$geometry
    geoloc$crs <- list(type="name",properties=list(name=paste0("EPSG:",enviro$srid)))
    enviro$localisation <- geoloc

    # enviro as a json list
    enviro[c("lat","lon","srid")] <- NULL
    environment_lst <- json_list(enviro)

    # Inject to environment table
    POST_table(environment_lst, "environment")

    print("enviro done")

  } else {

    print("enviro already in mangal")

  }
}
