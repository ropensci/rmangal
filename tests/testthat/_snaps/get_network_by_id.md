# get_network_by_id() works

    Code
      mg100
    Message
      
      -- Network #100 
      * Dataset: #36
      * Description: A survey of antarctic biology
      * Size: 32 edges, 14 nodes
      * Taxonomic IDs coverage for nodes:
      ITIS: 71%, BOLD: 64%, EOL: 71%, COL: 57%, GBIF: 29%, NCBI: 71%
      * Published in reference # DOI: NA

---

    Code
      mg_100c
    Message
      
      -- Network Collection --
      
      1 network in collection
      
      -- Network #100 
      * Dataset: #36
      * Description: A survey of antarctic biology
      * Size: 32 edges, 14 nodes
      * Taxonomic IDs coverage for nodes:
      ITIS: 71%, BOLD: 64%, EOL: 71%, COL: 57%, GBIF: 29%, NCBI: 71%
      * Published in reference # DOI: NA

# get_network_by_id() handles 404

    Code
      res <- get_network_by_id(id = c(18, 1e+08))
    Message
      x network id 100000000 not found.

