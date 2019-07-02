context("search_taxonomy")

res1 <- search_taxonomy("Acer")
res2 <- search_taxonomy("Acer japonicum")
resTsn <- search_taxonomy(tsn = 28749)
resNcbi <- search_taxonomy(ncbi = 47966)
resEol <- search_taxonomy(eol =  583069)
resBold <- search_taxonomy(bold = 100987)
resw <- search_taxonomy("Does not work")
res_j <- get_collection(res2)

test_that("expected behavior", {
  expect_true("mgSearchTaxonomy" %in% class(res1))
  expect_equal(dim(res1), c(5, 18))
  expect_equal(dim(res2), c(1, 18))
  expect_identical(resw, data.frame())
  expect_true(28749 %in% res1$taxonomy.tsn)
  expect_equal(resTsn$taxonomy.tsn, 28749)
  expect_equal(resNcbi$taxonomy.ncbi, 47966)
  expect_equal(resEol$taxonomy.eol, 583069)
  expect_equal(resBold$taxonomy.bold, 100987)
  # All Acer negundo
  expect_true(identical(resBold, resEol))
  expect_true(identical(resTsn, resEol))
  #
  expect_equal(length(res_j), 5)
  expect_equal(class(res_j), "mgNetwork")
  #
  expect_error(search_taxonomy(tsn = 123, bold = 456))
  expect_error(search_taxonomy(list(wrong = 123)))
})
