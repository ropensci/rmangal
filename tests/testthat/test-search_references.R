test_that("search_references() default and collection work", {
  vcr::use_cassette(name = "search_references_default", {
    res1 <- search_references(doi = "10.2307/3225248")
    resc <- get_collection(res1)
  })
  expect_s3_class(res1, "mgSearchReferences")
  expect_equal(length(res1), 13)
  expect_equal(res1$doi, "10.2307/3225248")
  expect_equal(class(resc), "mgNetworksCollection")
  expect_identical(names(resc[[1]]), nm_co)
})

test_that("search_references() using list works", {
  vcr::use_cassette(name = "search_references_list", {
    res <- search_references(list(jstor = 3683041))
  })
  expect_s3_class(res, "mgSearchReferences")
  expect_equal(res$jstor, "3683041")
})

# something weird with jstor output compare the 1st and 2nd query
# res3 <- suppressWarnings(search_references(doi = c("ok", "ok")))
# res4 <- search_references(list(year = 2010))
