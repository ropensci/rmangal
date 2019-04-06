context("test-search_networks")

library(sf)
res1 <- search_networks("lagoon")
area <- USAboundaries::us_states(state="california")
res2 <- search_networks(area)
resw <- search_networks("does not exist")
ress <- search_networks(query="insect%", output = "spatial")

test_that("errors caught", {
  expect_error(search_networks(query = 2011))
})

test_that("expected behavior", {
  expect_equal(dim(resw), c(0, 0))
  expect_equal(nrow(res1), 3)
  expect_equal(nrow(res2), 14)
  expect_equal(nrow(ress), 14)
})

test_that("output format", {
  expect_equal(class(res1), c(cl_df, "mgSearchNetworks"))
  expect_equal(class(res2), c("sf", "data.frame", "mgSearchNetworks"))
  expect_equal(class(ress), c("sf", "data.frame", "mgSearchNetworks"))
})

resc <- get_collection(res1)
test_that("get_collection", {
  expect_equal(class(resc), "mgNetworksCollection")
  expect_equal(class(resc[[1L]]), "mgNetwork")
  # at least one network per dataset
  expect_true(length(resc) == nrow(res1))
  expect_equal(names(resc[[1L]]), nm_co)
})
