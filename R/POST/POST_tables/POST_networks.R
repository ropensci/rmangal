### This is a test ###

### Erreur : ne saisie pas datasets_id ###

## Create and inject networks table ##

# Check if the networks already exist
server <- "http://localhost:3000"

path <- modify_url(server, path = paste0("/api/v0/","networks/?name=", networks[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = add_headers("Content-type" = "application/json")))) == 0) {
  
  # Retrive foreign key
  ## datasets_id
  networks <- c(networks, dataset_id = GET_fkey("datasets", "name", datasets[[1]]))
  
  ## ref_id
  networks <- c(networks, ref_id = GET_fkey("refs", "doi", refs[[1]]))
  
  ## environment_id
  networks <- c(networks, environment_id = GET_fkey("environments", "name", enviro[[1]]))
  
  ## user_id
  networks <- c(networks, user_id = GET_fkey("users", "name", users[[1]]))
  
  # networks_df as a json list
  networks_lst <- to_json_list(data.frame(networks))
  
  # Inject to networks table
  POST_table(networks_lst, "networks")
  
  print("network done")
  
} else {
  
  print("network already in mangal")
  
}