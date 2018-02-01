for (i in 1:1000) {
  DELETE( url = paste0("http://localhost:3000/api/v0/taxon/", i)) 
}


