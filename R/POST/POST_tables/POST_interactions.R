### This is a test ###
## Create and inject interactions table ##

inter_df <- interactions

# Retrive foreign keys
## taxon_1 & taxon_2
inter_df[, "taxon_1"] <- NA
inter_df[, "taxon_2"] <- NA

for (i in 1:nrow(inter_df)) {
  try(inter_df[i, "taxon_1"] <- GET_fkey("taxons", "name", inter_df[i,1]))
  try(inter_df[i, "taxon_2"] <- GET_fkey("taxons", "name", inter_df[i,2]))
} 

## attr_id
inter_df[, "attr_id"] <- GET_fkey("traits", "name", "Toundra")

##environment_id
inter_df[, "environment_id"] <- GET_fkey("environments", "name", "Toundra")

## network_id
inter_df[, "network_id"] <- GET_fkey("networks", "name", "Tundra plant pollinator")

## ref_id
inter_df[, "ref_id"] <- GET_fkey("refs", "doi", "GBtest")

## user_id
inter_df[, "user_id"] <- GET_fkey("users", "name", "Hocking")

# Remove unused column
inter_df <- inter_df[,3:ncol(inter_df)]

# inter_df as a json list
inter_lst <- to_json_list(inter_df)

# Inject to interactions table
POST_table(inter_lst, "interactions")

print("interactions done")