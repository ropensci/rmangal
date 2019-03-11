# Config de base
server <- function() "http://poisotlab.biol.umontreal.ca"
#server <- function() "http://localhost:8080" # dev purpose
base <- function() "/api/v2"
bearer <- function() ifelse(file.exists(".httr-oauth"), as.character(readRDS(".httr-oauth")), NA)
ua <- httr::user_agent("rmangal")

# Point d'entrées de l'API
endpoints <- function(){
  list(
    dataset = "/dataset",
    environment = "/environment",
    interaction = "/interaction",
    network = "/network",
    node = "/node",
    reference = "/reference",
    attribute = "/attribute",
    taxonomy = "/taxonomy",
    trait = "/trait"
  )
}
