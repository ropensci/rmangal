context("search_dataset")

res1 <- search_datasets(query = "lagoon")
res2 <- search_datasets(query = "2011")
res3 <- search_datasets(query = list(name = "kemp_1977"))

resw <- search_datasets(query = "does not exist")

test_that("errors caught", {
  expect_error(search_datasets(query = 2011))
  expect_equal(dim(resw), c(0, 0))
})
