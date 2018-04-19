#' @title List or extract the taxonomic backbone currently in Mangal
#' @export
#' 
#' @description Returns a list of the taxa or a specific taxa currently in the Mangal taxonomic backbone
#'
#' @param id ID of the object
#' @param filtering a vector of filters to restrict the returned objects

GetTaxa_back <- function(id = NULL, filtering = NULL) GetTable(id, filtering, table = "taxa_back", attribute = c("id", "name"))
# Test what happens when filterning use attribute names no in the table


#' @title List or extract users currently in Mangal
#' @export
#' 
#' @description Returns a list of users or a specific user currently in Mangal
#'
#' @param id ID of the object
#' @param filtering a vector of filters to restrict the returned objects

GetUsers <- function(id = NULL, filtering = NULL) GetTable(id, filtering, table = "users", attribute = c("id", "name"))


#' @title List or extract attributes currently in Mangal
#' @export
#' 
#' @description Returns a list of attributes or a specific attribute currently in Mangal
#'
#' @param id ID of the object
#' @param filtering a vector of filters to restrict the returned objects

GetAttribute <- function(id = NULL, filtering = NULL) GetTable(id, filtering, table = "attribute", attribute = c("id", "name", "unit"))


#' @title List or extract references currently in Mangal
#' @export
#' 
#' @description Returns a list of references or a specific reference currently in Mangal
#'
#' @param id ID of the object
#' @param filtering a vector of filters to restrict the returned objects

GetRef <- function(id = NULL, filtering = NULL) GetTable(id, filtering, table = "ref", attribute = c("id", "doi", "author", "year"))


#' @title List or extract datasets currently in Mangal
#' @export
#' 
#' @description Returns a list of datasets or a specific dataset currently in Mangal
#'
#' @param id ID of the object
#' @param filtering a vector of filters to restrict the returned objects

GetDataset <- function(id = NULL, filtering = NULL) GetTable(id, filtering, table = "dataset", attribute = c("id", "name", "description"))


#' @title List or extract networks currently in Mangal
#' @export
#' 
#' @description Returns a list of networks or a specific network currently in the Mangal
#'
#' @param id ID of the object
#' @param filtering a vector of filters to restrict the returned objects

GetNetwork <- function(id = NULL, filtering = NULL) GetTable(id, filtering, table = "network", attribute = c("id", "name", "description"))