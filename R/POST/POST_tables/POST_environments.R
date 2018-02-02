### This is a test ###
## Create and inject environments table ##

# Check if the environments already exist
server <- "http://localhost:3000"

path <- modify_url(server, path = paste0("/api/v0/","environments/?name=",enviro[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = add_headers("Content-type" = "application/json")))) == 0) {
  
  # Retrive foreign key
  ## attr_id
  enviro <- c(enviro, attr_id = GET_fkey("attributes", "name", attr[[1]]))
  
  ## ref_id
  enviro <- c(enviro, ref_id = GET_fkey("refs", "doi", refs[[1]]))
  
  # Environments_df as a json list
  environments_lst <- to_json_list(data.frame(enviro))
  
  # Inject to environment table
  POST_table(environments_lst, "environments")
  
  print("enviro done")
    
} else {
  
  print("enviro already in mangal")
  
}