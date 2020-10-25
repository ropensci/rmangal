context("conversion to igraph object")

# Prep test on mgNetwork
test_that("as.igraph works", {
  vcr::use_cassette("mg100", {
    mg100 <- get_network_by_id(100)
  })
  vcr::use_cassette("mg100", {
    net_100 <- as.igraph(mg100)
  })
  vcr::use_cassette("net_clo", {
    net_clo <- get_collection(search_datasets("closs"))
  })
  vcr::use_cassette("net_collection", {
    net_collection <- as.igraph(net_clo)
  })
  
  expect_equal(length(net_collection), 12)
  expect_true(class(net_100) == "igraph")
  expect_true(all(lapply(net_collection, class) == "igraph"))
  expect_true("tbl_graph" %in% class(tidygraph::as_tbl_graph(mg100)))
  #
  res <- summary(mg100)
  expect_equal(length(res), 5)
  expect_equal(ncol(res$nodes_summary), 4)
  expect_equal(res$n_nodes, 32)
  expect_equal(class(summary(combine_mgNetworks(mg100, mg100))), "list")
})
