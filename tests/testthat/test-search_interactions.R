test_that("search_interactions() default works", {
  vcr::use_cassette(name = "search_interactions_default", {
    res <- search_interactions(type = "competition")
    #
  })
  expect_equal(dim(res), c(12, 20))
  expect_s3_class(res, "mgSearchInteractions")
  expect_snapshot(res)
})

test_that("search_interactions() type and expand_node work", {
  vcr::use_cassette(name = "search_interactions_type", {
    res <- search_interactions(type = "competition", expand_node = TRUE)
  })
  # this may change if we merge data frames
  expect_s3_class(res, "mgSearchInteractions")
  expect_equal(dim(res), c(12, 56))
  expect_true(all(res$type == "competition"))
})

test_that("search_interactions()", {
  vcr::use_cassette(name = "search_interactions_id100", {
    res <- search_interactions(list(network_id = 100))
    resc <- get_collection(res)
  })
  expect_s3_class(res, "mgSearchInteractions")
  expect_true(all(res$network_id == 100))
  #
  expect_s3_class(resc, "mgNetworksCollection")
  expect_equal(names(resc[[1L]]), nm_co)
})


test_that("search_interactions() handles 404", {
  vcr::use_cassette(name = "search_interactions_404", {
    expect_snapshot(res1 <- search_interactions(query = "this_is_wrong"))
  })
  expect_identical(res1, data.frame())
})
