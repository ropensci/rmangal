context("combine_mgNetworks")

net_19 <- search_networks(list(dataset_id = 19))
mg_19 <- get_collection(net_19)
mg_lagoon <- get_collection(search_datasets(query='lagoon%'))

res1 <- combine_mgNetworks(mg_19, mg_lagoon)
res2 <- combine_mgNetworks(list(mg_19, mg_lagoon))
res3 <- combine_mgNetworks(mg_19)
res4 <- combine_mgNetworks(mg_lagoon)

test_that("expected behavior", {
  expect_equal(class(res1), "mgNetworksCollection")
  expect_equal(class(res2), "mgNetworksCollection")
  expect_equal(class(res3), "mgNetworksCollection")
  expect_equal(class(res4), "mgNetworksCollection")
  expect_identical(res1, res2)
  expect_equal(length(res1), 4)
  expect_equal(length(res2), 4)
  expect_equal(length(res3), 1)
  expect_equal(length(res4), 3)
  expect_error(combine_mgNetworks(list(list(mg_19))))
}
)
