### This is a test ###
## Create and inject refs table ##

# Check if the refs already exist
server <- "http://localhost:3000"

path <- modify_url(server, path = paste0("/api/v0/","refs/?doi=",refs[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = add_headers("Content-type" = "application/json")))) == 0) {
 
  # Refs_df as a json list
  refs_lst <- to_json_list(data.frame(refs))

  # Inject to refs table
  POST_table(refs_lst, "refs")
  
  print("ref done")
  
} else {
  
  print("ref already in mangal")

}