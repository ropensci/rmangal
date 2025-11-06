# search_datasets() no match works

    Code
      res <- search_datasets(query = "does not exist")
    Message
      No dataset found.

# search_datasets() handles 404

    Code
      res1 <- search_datasets(query = "this_is_wrong")
    Message
      No dataset found.

