context("search_interactions")


res1 <- search_interactions("competition")
res2 <- search_interactions("competition", TRUE, TRUE)


test_that("expected behavior", {
  expect_error(search_interactions("wrong"))
  expect_equal(dim(res1), c(12, 21))
  expect_equal(class(res1), c("sf", "data.frame", "mgSearchInteractions"))
  # this may change if we merge data frames
  # expect_equal(dim(res2), c(12, 21))
})


resc <- get_collection(res1)
test_that("get_collection", {
  expect_equal(class(resc), "mgNetworksCollection")
  expect_equal(class(resc[[1L]]), "mgNetwork")
  expect_equal(names(resc[[1L]]), nm_co)
})
