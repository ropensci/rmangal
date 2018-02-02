### This is a test ###
## Create and inject users table ##

# Check if the users already exist
server <- "http://localhost:3000"

path <- modify_url(server, path = paste0("/api/v0/","users/?name=",users[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = add_headers("Content-type" = "application/json")))) == 0) {
  
  # users_df as a json list
  users_lst <- to_json_list(data.frame(users))
  
  # Inject to users table
  POST_table(users_lst, "users")
  
  #Probleme : refuse d'ajouter d'autre champ que "name"
  
  print("user done")  
  
} else {
  
  print("user already in mangal")
  
}