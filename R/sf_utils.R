#' Fonction générique pour convertir les sorties de l'API en objet de classe spatiale (sf)
#'
#' @param data `list` de la classe `coleoGetResp` retourné par les fonctions GET du package coléo (ex. [get_sites()]) ou `data.frame` ([as.data.frame]) , voir @details
#' @return
#' Retourne un objet de la classe `sf::st_sf`
#' @examples
#' \dontrun{
#' plot(cl_to_sf(get_sites()))
#' } 
#' @details L'objet d'entrée doit contenir les colonnes `geom.type` & `geom.coordinates`
#' @seealso [sf_cells()], [sf_sites()]
#' @export

cl_to_sf <- function(data){
  UseMethod("cl_to_sf")
}

#' @rdname cl_to_sf
#' @export
cl_to_sf.coleoGetResp <- function(data) {

  # Check for getSuccess classes
  stopifnot(all(lapply(unlist(data,recursive=FALSE),class) == "getSuccess"))

  # get features
  features <- lapply(data, function(request){
    lapply(request, function(page){
      features <- apply(page$body, 1, function(feature){
        return(list(type="Feature", geometry=list(type=feature$geom.type,coordinates=feature$geom.coordinates)))
      })
      names(features) <- NULL
      return(features)
    })
  })

  features <- unlist(unlist(features,recursive=FALSE),recursive=FALSE)

  # get Data
  geom_s <- sf::read_sf(
    jsonlite::toJSON(
      list(
        type="FeatureCollection",
        features=features),
        auto_unbox=TRUE
    )
  )

  geom_df <- lapply(data, function(request){
    all_pages <- lapply(request, function(page){
      dplyr::select(page$body, -dplyr::one_of("geom.type","geom.coordinates"))
    })
    return(do.call(rbind,all_pages))
  })

  geom_df <- do.call(rbind,geom_df)

  # Data binding
  geom_sdf <- sf::st_sf(dplyr::bind_cols(geom_df,geom_s))

  return(geom_sdf)
}

#' @rdname cl_to_sf
#' @export
cl_to_sf.data.frame <- function(data) {

  # get features
  features <- apply(data, 1, function(feature){
    return(list(type="Feature", geometry=list(type=feature$geom.type,coordinates=feature$geom.coordinates)))
  })

  # get Data
  geom_s <- sf::read_sf(
    jsonlite::toJSON(
      list(
        type="FeatureCollection",
        features=features),
        auto_unbox=TRUE
    )
  )

  geom_df <- dplyr::select(data, -dplyr::one_of("geom.type","geom.coordinates"))

  # Data binding
  geom_sdf <- sf::st_sf(dplyr::bind_cols(geom_df,geom_s))

  return(geom_sdf)
}
