## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(rmangal)
library(magrittr)
library(USAboundaries)
library(mapview)
library(igraph)

## ------------------------------------------------------------------------
all_datasets <- search_datasets()
all_datasets[1:6, c("id", "name" ,"description")]

## ------------------------------------------------------------------------
all_networks <- search_networks()
mapview(all_networks, legend = FALSE)

## ------------------------------------------------------------------------
lagoon <- search_datasets(query = 'lagoon')
net_lagoons <- get_collection(lagoon)

## ------------------------------------------------------------------------
ig_lagoons <- as.igraph(net_lagoons)
plot(ig_lagoons[[1]], vertex.label = vertex_attr(ig_lagoons[[1]],"original_name"))

## ------------------------------------------------------------------------
all_networks <- search_networks()
netw18 <- get_network_by_id(id = 18)
## 2B fixed
collec <- search_networks(query="insect%") %>% get_collection()
collec[[1]]

## ------------------------------------------------------------------------
sr_ficus <- search_taxa("Ficus") 
# Plot the location
mapview(sr_ficus$networks, legend=FALSE)
# Get networks
net_ficus <- get_collection(sr_ficus)
net_ficus[[1]]

## ------------------------------------------------------------------------
area <- us_states(state = "california")
networks_in_area <- search_networks(area)
mapview(networks_in_area, legend = FALSE)

## ------------------------------------------------------------------------
resTsn <- search_taxa(tsn = 28749)
resNcbi <- search_taxa(ncbi = 47966)
resEol <- search_taxa(eol =  583069)
resBold <- search_taxa(bold = 100987)

