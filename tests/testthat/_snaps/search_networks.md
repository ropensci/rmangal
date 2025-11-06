# search_networks() default and collection work

    Code
      res1
    Output
         id                    name                     date
      1  86 zetina_2003_20030101_86 2003-01-01T00:00:00.000Z
      2 927 yanez_1978_19730901_927 1973-09-01T00:00:00.000Z
      3 926 yanez_1978_19730901_926 1973-09-01T00:00:00.000Z
                                            description public all_interactions
      1 Dietary matrix of the Huizache–Caimanero lagoon   TRUE            FALSE
      2                 Food web of the Brackish lagoon   TRUE            FALSE
      3                   Food web of the Costal lagoon   TRUE            FALSE
                      created_at               updated_at dataset_id user_id
      1 2019-02-23T17:04:34.046Z 2019-02-23T17:04:34.046Z         22       3
      2 2019-02-25T15:09:11.020Z 2019-02-25T15:09:11.020Z         52       3
      3 2019-02-25T15:09:10.651Z 2019-02-25T15:09:10.651Z         52       3
        geom_type  geom_lon geom_lat
      1     Point -106.1099 22.98531
      2     Point -100.3656 17.06915
      3     Point -100.3656 17.06915

# search_networks() handles 404

    Code
      res1 <- search_networks(query = "this_is_wrong")
    Message
      No network found.

