context("mg_to_igraph")

# Prep test on mgNetwork
net_100 <- mg_to_igraph(get_network_by_id(100))
net_collection <- mg_to_igraph(get_collection(search_datasets("closs")))

test_that("expected behavior", {
  expect_equal(length(net_collection), 12)
  expect_true(class(net_100) == "igraph")
  expect_true(all(lapply(net_collection, class) == "igraph"))
})
