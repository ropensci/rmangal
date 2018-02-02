### This is a test ###
## Create and inject taxons table ##

# Retrive foreign key <- Pour l'instant qu'un seul trait donc commun a tous
## trait_id
taxons_df[,6] <- GET_fkey("traits", "name", traits[[1]])

# taxon_df as a json list
taxons_lst <- to_json_list(taxons_df)

# Inject to networks table
POST_table(taxons_lst, "taxons")

print("taxons done")