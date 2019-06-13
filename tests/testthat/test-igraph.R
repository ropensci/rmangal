iNet <- as.igraph(get_collection(c(19,12)))

context("as.igraph")

test_that("expected behaviour", {
  expect_equal(length(iNet), 2)
  expect_true(class(iNet) == "igraph")
})