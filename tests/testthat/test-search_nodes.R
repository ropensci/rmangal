skip_if_not_installed("vcr")
test_that("search_nodes() default works", {
  vcr::use_cassette(name = "search_nodes_default", {
    res <- search_nodes("Acer")
  })
  expect_s3_class(res, "mgSearchNodes")
  expect_true(all(dim(res) == c(5, 18)))
  expect_snapshot(res)
})


test_that("search_nodes() find 926 and get collection", {
  vcr::use_cassette(name = "search_nodes_id926", {
    res <- search_nodes(list(network_id = 926))
    net <- get_collection(res)
  })
  expect_s3_class(res, "mgSearchNodes")
  expect_s3_class(net, "mgNetworksCollection")
  expect_true(all(dim(res) == c(13, 18)))
  expect_true(all(names(net[[1]]) == nm_co))
})


test_that("search_networks() handles 404", {
  vcr::use_cassette(name = "search_nodes_404", {
    expect_snapshot(res1 <- search_nodes(query = "this_is_wrong"))
  })
  expect_identical(res1, data.frame())
})
