test_that("search_nodes() default works", {
  vcr::use_cassette(name = "search_nodes_default", {
    res <- search_nodes("Acer", verbose = FALSE)

  })
  expect_s3_class(res, "mgSearchNodes")
  expect_true(all(dim(res) == c(5, 18)))
})


test_that("search_nodes() find 926 and get collection", {
  vcr::use_cassette(name = "search_nodes_id926", {
    res <- search_nodes(list(network_id = 926), verbose = FALSE)
    net <- get_collection(res, verbose = FALSE)
  })
  expect_s3_class(res, "mgSearchNodes")
  expect_s3_class(net, "mgNetworksCollection")
  expect_true(all(dim(res) == c(13, 18)))
  expect_true(all(names(net[[1]]) == nm_co))
})

