context("test-search_taxa")

res1 <- search_taxa("Acer")
resTsn <- search_taxa(tsn = 182132)
resNcbi <- search_taxa(ncbi = 47966)
resBold <- search_taxa(bold = 102197)
res2 <- search_taxa("Acer", orginal = TRUE)
resw <- search_taxa("Does not work")

test_that("expected behavior", {
  expect_true("mgSearchTaxa" %in% class(res1))
  expect_equal(dim(res1), c(5, 13))
  expect_equal(dim(res2), c(5, 13))
  expect_equal(dim(resw), c(0, 0))
  expect_true(28749 %in% res1$tsn)
})
