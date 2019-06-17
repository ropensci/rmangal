context("get_collection")

res0 <- get_collection(c(1035:1036))
res1 <- get_collection(search_networks(query='insect%'))
res2 <- get_collection(search_datasets(query='lagoon%'))


test_that("expected behavior", {
  expect_equal(res0[[1]]$network$id, 1035)
  expect_equal(class(res1), "mgNetworksCollection")
  expect_equal(class(res1), "mgNetworksCollection")
  expect_equal(class(res1), "mgNetworksCollection")
  expect_equal(length(res0), 2)
  expect_equal(length(res1), 14)
  expect_equal(length(res2), 3)
}
)
