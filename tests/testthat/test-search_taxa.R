context("test-search_taxa")

res1 <- search_taxa("Acer")
res2 <- search_taxa("Acer", orginal = TRUE)
resw <- search_taxa("Does not work")


test_that("expected behavior", {
  expect_true("mgSearchTaxa" %in% class(res1))
  expect_equal(dim(res1), c(5, 11))
  expect_equal(dim(res2), c(5, 11))
  expect_equal(dim(resw), c(0, 0))
  expect_true(182132 %in% res1$tsn)
})
