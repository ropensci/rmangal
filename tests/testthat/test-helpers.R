df <- data.frame(
    taxonomy.tsn = c(1, 2),
    taxonomy.bold = c(1, 2),
    taxonomy.col = c(1, 2),
    taxonomy.eol = c(1, NA),
    taxonomy.gbif = c(1 ,2),
    taxonomy.ncbi = c(1 ,2)
)

test_that("basic prints work", {
  expect_equal(percent_id(df$taxonomy.eol), 50)
  expect_snapshot(print_taxo_ids(df))
  expect_snapshot(print_pub_info(list(doi = 2, id = 1)))
  expect_snapshot(print_net_info(1, 1, 1, 1, 1))
})


test_that("handle_query works", {
    expect_identical(handle_query("cool", c("id")), list(q = "cool"))
    expect_identical(handle_query(list(id = 1), c("id")), list(id = 1))
    expect_error(
      handle_query(1, c("id")),
      "`query` should either be a list or a character string\\."
    )
    expect_error(
      handle_query(list(id2 = 1), c("id")), 
      "Only id are valid names for custom queries\\."
    )
})

