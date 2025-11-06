test_that("search_taxonomy() default and collection work", {
  vcr::use_cassette(name = "search_taxonomy_default", {
    res <- search_taxonomy("Azorina vidalii")
    net <- get_collection(res)
  })
  expect_s3_class(res, "mgSearchTaxonomy")
  expect_s3_class(net, "mgNetworksCollection")
  expect_equal(res$taxonomy.name, "Azorina vidalii")
  expect_equal(dim(res), c(1, 18))
  expect_equal(length(net[[1L]]), 5)
})


test_that("search_taxonomy() querying specific id works", {
  vcr::use_cassette(name = "search_taxonomy_taxid", {
    res_tsn <- search_taxonomy(tsn = 28749)
    res_ncbi <- search_taxonomy(ncbi = 47966)
    res_eol <- search_taxonomy(eol = 583069)
    res_bold <- search_taxonomy(bold = 100987)
  })
  expect_equal(res_tsn$taxonomy.tsn, 28749)
  expect_equal(res_ncbi$taxonomy.ncbi, 47966)
  expect_equal(res_eol$taxonomy.eol, 583069)
  expect_equal(res_bold$taxonomy.bold, 100987)
  # All Acer negundo
  expect_true(identical(res_bold, res_eol))
  expect_true(identical(res_tsn, res_eol))
})

test_that("search_taxonomy() handles 404", {
  vcr::use_cassette(name = "search_taxonomy_404", {
    expect_snapshot(res1 <- search_references(query = "this_is_wrong"))
  })
  expect_identical(res1, data.frame())
})