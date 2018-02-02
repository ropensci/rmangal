### This is a test ###
## Create and inject attributes table ##

# Check if the attribute already exist
server <- "http://localhost:3000"

path <- modify_url(server, path = paste0("/api/v0/","attributes/?name=",attr[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = add_headers("Content-type" = "application/json")))) == 0) {
  
  # Attibutes_df as a json list
  attributes_lst <- to_json_list(data.frame(attr))
  
  # Inject to attributes table
  POST_table(attributes_lst, "attributes")
  
  print("attr done")
  
} else {
  
  print("attr already in mangal")

}