context("test search_datasets")

# number of variables (columns)
nvr <- 10

res1 <- search_datasets(query = "lagoon")
res2 <- search_datasets(query = list(name = "kemp_1977"))
res3 <- search_datasets(query = "2011")

resw <- search_datasets(query = "does not exist")

test_that("errors caught", {
  expect_error(search_datasets(query = 2011))
})

test_that("expected behavior", {
  expect_equal(dim(resw), c(0, 0))
  expect_equal(dim(res1), c(2, nvr))
  expect_equal(dim(res2), c(1, nvr))
  expect_equal(dim(res3), c(9, nvr))
})


test_that("output format", {
  expect_equal(class(res3), c(cl_df, "mgSearchDatasets"))
})


resc <- get_collection(res1)
test_that("get_collection", {
  expect_equal(class(resc), "mgNetworksCollection")
  expect_equal(class(resc[[1L]]), "mgNetwork")
  # at least one network per dataset
  expect_true(length(resc) >= nrow(res1))
  expect_equal(names(resc[[1L]]), nm_co)
})
