test_that("search_interactions() default works", {
  vcr::use_cassette(name = "search_interactions_default", {
    res <- search_interactions(type = "competition", verbose = FALSE)
    # 
  })
  expect_equal(dim(res), c(12, 19))
  expect_s3_class(res, "mgSearchInteractions")
})

test_that("search_interactions() type and expand_node work", {
  vcr::use_cassette(name = "search_interactions_type", {
    res <- search_interactions(type = "competition", expand_node = TRUE)
  })
  # this may change if we merge data frames
  expect_s3_class(res, "mgSearchInteractions")
  expect_equal(dim(res), c(12, 55))
  expect_true(all(res$type == "competition"))
  
})

test_that("search_interactions()", {
  vcr::use_cassette(name = "search_interactions_id100", {
    res <- search_interactions(list(network_id = 100), verbose = FALSE)
    resc <- get_collection(res)
  })
  expect_s3_class(res, "mgSearchInteractions")
  expect_true(all(res$network_id == 100))
  #
  expect_s3_class(resc, "mgNetworksCollection")
  expect_equal(names(resc[[1L]]), nm_co)
})





