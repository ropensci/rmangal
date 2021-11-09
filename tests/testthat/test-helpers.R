df <- data.frame(
    taxonomy.tsn = c(1, 2),
    taxonomy.bold = c(1, 2),
    taxonomy.col = c(1, 2),
    taxonomy.eol = c(1, NA),
    taxonomy.gbif = c(1 ,2),
    taxonomy.ncbi = c(1 ,2)
)

txt0 <- "* Current taxonomic IDs coverage for nodes of this network: \n  --> "
txt1 <- "ITIS: 100%, BOLD: 100%, EOL: 50%, COL: 100%, GBIF: 100%, NCBI: 100%\n"
txt2 <- "* Published in ref #1 DOI:2"
txt3 <- "* Network #1 included in dataset #1\n* Description: 1\n* Includes 1 edges and 1 nodes \n"

test_that("basic prints work", {
  expect_equal(percent_id(df$taxonomy.eol), 50)
  expect_equal(print_taxo_ids(df), paste0(txt0, txt1))
  expect_equal(print_pub_info(list(doi = 2, id = 1)), txt2)
  expect_equal(print_net_info(1, 1, 1, 1, 1), txt3)
})

test_that("clear cache works", {
  expect_true(clear_cache_rmangal())
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



test_that("fail gracefully", {
  df1 <- data.frame(var = 1, geom_type = "wrong", geom_lon = 1,  geom_lat = 2)
  vcr::use_cassette(name = "get_404", {
    resp <- httr::GET("http://httpbin.org/status/404")
  })
  expect_error(switch_df(df1))
  expect_error(stop_if_missing_sf("xx_xx"))
  expect_warning(msg_request_fail(resp), "API request failed: error 404")
})





