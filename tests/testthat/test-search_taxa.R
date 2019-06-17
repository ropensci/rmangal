context("search_taxa")


res1 <- search_taxa("Acer")
resTsn <- search_taxa(tsn = 28749)
resNcbi <- search_taxa(ncbi = 47966)
resEol <- search_taxa(eol =  583069)
resBold <- search_taxa(bold = 100987)
res2 <- search_taxa("Acer", orginal = TRUE)
resw <- search_taxa("Does not work")
# small_net <- get_collection(search_taxa("superba"))

test_that("expected behavior", {
  expect_true("mgSearchTaxa" %in% class(res1))
  expect_equal(dim(res1), c(5, 19))
  expect_equal(dim(res2), c(5, 19))
  expect_equal(dim(resw), c(0, 0))
  expect_true(28749 %in% res1$taxonomy.tsn)
  expect_equal(resTsn$taxonomy.tsn, 28749)
  expect_equal(resNcbi$taxonomy.ncbi, 47966)
  expect_equal(resEol$taxonomy.eol, 583069)
  expect_equal(resBold$taxonomy.bold, 100987)
  # All Acer negundo
  expect_true(identical(resBold, resEol))
  expect_true(identical(resTsn, resEol))
  # expect_equal(length(small_net), 2)
})
