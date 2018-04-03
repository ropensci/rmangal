#' @description Create the global parameters to acces the api
#'
#' @author Gabriel Bergeron
#'
#' @importFrom httr modify_url

# Cache env
mangal.env <- new.env(parent = emptyenv())

# Base URL
mangal.env$prod <- list()

# Config
mangal.env$base <- "/api/v2"
mangal.env$headers <- httr::add_headers("Content-type" = "application/json",
                                        "Authorization" = paste("bearer", readRDS(".httr-oauth")))

# Production environment
mangal.env$prod$server <- "http://poisotlab.biol.umontreal.ca"
