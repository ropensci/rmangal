# basic prints work

    Code
      print_taxo_ids(df)
    Message
      * Taxonomic IDs coverage for nodes:
      ITIS: 100%, BOLD: 100%, EOL: 50%, COL: 100%, GBIF: 100%, NCBI: 100%

---

    Code
      print_pub_info(list(doi = 2, id = 1))
    Message
      * Published in reference #{x$id} DOI: 2

---

    Code
      print_net_info(1, 1, 1, 1, 1)
    Message
      
      -- Network #{net_id} --
      
      * Dataset: #{dat_id}
      * Description: 1
      * Size: 1 edge, 1 node

