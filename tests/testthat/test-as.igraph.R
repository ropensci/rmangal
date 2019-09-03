context("conversion to igraph object")

# Prep test on mgNetwork
mg100 <- get_network_by_id(100)
net_100 <- as.igraph(mg100)
net_clo <- get_collection(search_datasets("closs"))
net_collection <- as.igraph(net_clo)

test_that("expected behavior", {
  expect_equal(length(net_collection), 12)
  expect_true(class(net_100) == "igraph")
  expect_true(all(lapply(net_collection, class) == "igraph"))
  expect_true("tbl_graph" %in% class(tidygraph::as_tbl_graph(mg100)))
})


test_that("summary", {
  res <- summary(mg100)
  expect_equal(length(res), 5)
  expect_equal(ncol(res$nodes_summary), 4)
  expect_equal(res$n_nodes, 32)
  expect_equal(class(summary(combine_mgNetworks(mg100, mg100))), "list")
})
