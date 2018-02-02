### This is a test ###
## Create and inject datasets table ##

# Check if the datasets already exist
server <- "http://localhost:3000"

path <- modify_url(server, path = paste0("/api/v0/","datasets/?name=",datasets[[1]]))

# Is retreived content == 0 -> in this case inject data
if (length(content(GET(url = path, config = add_headers("Content-type" = "application/json")))) == 0) {

  # Retrive foreign key
  ## user_id
  datasets <- c(datasets, user_id = GET_fkey("users","name", users[[1]]))
  
  ## ref_id
  datasets <- c(datasets, ref_id = GET_fkey("refs", "doi", refs[[1]]))
  
  # Datasets_df as a json list
  datasets_lst <- to_json_list(data.frame(datasets))
  
  # Inject  to datasets table
  POST_table(datasets_lst, "datasets")
  
  print("datasets done")  
  
} else {
  
  print("dataset already in mangal")
  
}