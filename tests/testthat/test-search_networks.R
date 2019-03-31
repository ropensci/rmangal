context("test-search_networks")

# number of variables (columns)
nvr <- 11

res1 <- search_networks("lagoon")
# area <- USAboundaries::us_states(state="california")
# res2 <- search_networks(area)
resw <- search_networks("does not exist")
ress <- search_networks(query="insect%", output = "spatial")

test_that("errors caught", {
  expect_error(search_networks(query = 2011))
})

test_that("expected behavior", {
  expect_equal(dim(resw), c(0, 0))
  expect_equal(nrow(res1), 3)
  # expect_equal(nrow(res2), 14)
  expect_equal(nrow(ress), 14)
})

test_that("expected behavior", {
  expect_equal(dim(resw), c(0, 0))
  expect_equal(nrow(res1), 3)
  # expect_equal(nrow(res2), 14)
})

test_that("output format", {
  expect_equal(class(res1), c("tbl_df", "tbl", "data.frame", "mgSearchNetworks"))
  # expect_equal(class(res2), c("sf", "data.frame", "mgSearchNetworks"))
  expect_equal(class(ress), c("sf", "data.frame", "mgSearchNetworks"))
})
