context("search_interactions")


res1 <- search_interactions("competition")
res2 <- search_interactions("competition", TRUE, TRUE)


test_that("expected behavior", {
  expect_error(search_interactions("wrong"))
  expect_equal(dim(res1), c(12, 21))
  expect_equal(class(res1), c(cl_df, "mgSearchInteractions"))
  # this may change if we merge data frames
  expect_equal(dim(res2), c(12, 21))
  expect_equal(class(res2$node_from), cl_df)
})
