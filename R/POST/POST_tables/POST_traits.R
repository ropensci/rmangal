### This is a test ###
## Create and inject traits table ##

# Check if the traits already exist
server <- "http://localhost:3000"

path <- modify_url(server, path = paste0("/api/v0/","traits/?name=", traits[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = add_headers("Content-type" = "application/json")))) == 0) {

  # Retrive foreign key
  ## attr_id
  traits <- c(traits, attr_id = GET_fkey("attributes", "name", attr[[1]]))
  
  ## ref_id
  traits <- c(traits, ref_id = GET_fkey("refs", "doi", refs[[1]]))
  
  # traits_df as a json list
  traits_lst <- to_json_list(data.frame(traits))
  
  # Inject to traits table
  POST_table(traits_lst, "traits")
  
  print("trait done")  
  
} else {
  
  print("trait already in mangal")
  
}