# search_nodes() default works

    Code
      res
    Output
          id     original_name node_level network_id taxonomy_id
      1 2629      Acer negundo      taxon         19           2
      2 2630  Acer saccharinum      taxon         19           3
      3 8895 Acer shirasawanum      taxon        948        3117
      4 8923 Acer ukurunduense      taxon        948        3144
      5 8930    Acer japonicum      taxon        948        3151
                      created_at               updated_at taxonomy.id
      1 2019-02-22T18:48:49.433Z 2019-02-22T18:48:49.433Z           2
      2 2019-02-22T18:48:49.465Z 2019-02-22T18:48:49.465Z           3
      3 2019-02-25T20:52:53.654Z 2019-02-25T20:52:53.654Z        3117
      4 2019-02-25T20:52:54.835Z 2019-02-25T20:52:54.835Z        3144
      5 2019-02-25T20:52:55.175Z 2019-02-25T20:52:55.175Z        3151
            taxonomy.name taxonomy.ncbi taxonomy.tsn taxonomy.eol taxonomy.bold
      1      Acer negundo          4023        28749       583069        100987
      2  Acer saccharinum         75745        28757       583072        101028
      3 Acer shirasawanum         66216           NA      5613162        485602
      4     Acer caudatum        290844           NA      2888949        102168
      5    Acer japonicum         47966       837855      2888970        448667
        taxonomy.gbif                     taxonomy.col taxonomy.rank
      1       3189866 90203e29e2f59e5754167f89b9eba3cc       species
      2       3189837 1582ed5db846e241f3e18da418a2a477       species
      3       7263086 25b4371fbbdc5b1cd43fad895050cc05       species
      4       7263099 1211e426bdec174da9a7526348c26fb9       species
      5       8010851 3388e995334d5638aeb11ef84f98b319       species
             taxonomy.created_at      taxonomy.updated_at
      1 2019-02-21T21:17:12.585Z 2019-06-14T15:20:36.273Z
      2 2019-02-21T21:17:12.637Z 2019-06-14T15:20:36.328Z
      3 2019-02-22T00:31:49.729Z 2019-06-14T15:24:56.217Z
      4 2019-02-22T00:31:52.729Z 2019-06-14T15:24:57.854Z
      5 2019-02-22T00:31:53.328Z 2019-06-14T15:24:58.251Z

# search_networks() handles 404

    Code
      res1 <- search_nodes(query = "this_is_wrong")

