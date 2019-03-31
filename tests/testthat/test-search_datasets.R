context("search_dataset")

# number of variables (columns)
nvr <- 11

res1 <- search_datasets(query = "lagoon")
res2 <- search_datasets(query = list(name = "kemp_1977"))
res3 <- search_datasets(query = "2011")
# does not work
# res4 <- search_datasets(query = "2011", output = "list")

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
  expect_equal(class(resw), c("tbl_df", "tbl", "data.frame", "mgSearchDatasets"))
  expect_equal(class(res3), c("tbl_df", "tbl", "data.frame", "mgSearchDatasets"))
})
