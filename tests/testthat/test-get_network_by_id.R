# Prep test on mgNetwork
test_that("get_network_by_id() works", {
  vcr::use_cassette("mg100", {
    mg100 <- get_network_by_id(100)
  })
  expect_s3_class(mg100, "mgNetwork")
  expect_equal(mg100$network$network_id, 100)

  net_100 <- as.igraph(mg100)
  expect_s3_class(net_100, "igraph")
  expect_error(suppressWarnings(get_network_by_id(id = 999999)))

  smy <- summary(mg100)
  expect_equal(length(smy), 5)
  expect_equal(ncol(smy$nodes_summary), 4)
  expect_equal(smy$n_edges, length(igraph::E(net_100)))
  expect_equal(smy$n_nodes, length(igraph::V(net_100)))


  cbn <- combine_mgNetworks(mg100, mg100)
  expect_s3_class(cbn, "mgNetworksCollection")
  expect_equal(length(cbn), 2)

  smy2 <- summary(cbn)
  expect_type(summary(cbn), "list")
  expect_identical(smy$linkage_density, smy2[[1]]$linkage_density)

  cbn3 <- combine_mgNetworks(cbn, mg100)
  expect_s3_class(cbn3, "mgNetworksCollection")
  expect_equal(length(cbn3), 3)

  cbn4 <- combine_mgNetworks(cbn, cbn)
  expect_s3_class(cbn4, "mgNetworksCollection")
  expect_equal(length(cbn4), 4)

  expect_error(combine_mgNetworks(list(list(mg100))))

})
