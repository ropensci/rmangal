context("search_reference")

res1 <- search_reference(doi = "10.2307/3225248")

test_that("expected behavior", {
  expect_error(search_reference())
  expect_equal(class(res1), "mgSearchReference")
  expect_equal(length(res1), 13)
})


resc <- get_collection(res1)
test_that("get_collection", {
  expect_equal(class(resc), "mgNetwork")
  expect_identical(names(resc), nm_co)
})
