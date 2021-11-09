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
    resTsn <- search_taxonomy(tsn = 28749)
    resNcbi <- search_taxonomy(ncbi = 47966)
    resEol <- search_taxonomy(eol =  583069)
    resBold <- search_taxonomy(bold = 100987)
  })
    expect_equal(resTsn$taxonomy.tsn, 28749)
    expect_equal(resNcbi$taxonomy.ncbi, 47966)
    expect_equal(resEol$taxonomy.eol, 583069)
    expect_equal(resBold$taxonomy.bold, 100987)
    # All Acer negundo
    expect_true(identical(resBold, resEol))
    expect_true(identical(resTsn, resEol))
})

# 
# 
# expect_error(search_taxonomy(tsn = 123, bold = 456))
# expect_error(search_taxonomy(list(wrong = 123)))