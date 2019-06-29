context("search_reference")

res1 <- search_reference(doi = "10.2307/3225248")
res2 <- search_reference(list(jstor = 3683041))
res3 <- suppressWarnings(search_reference(doi = c("10.2307/3225248", "ok")))
resw <- search_reference("wrong")

test_that("expected behavior", {
  expect_error(search_reference())
  expect_equal(class(res1), "mgSearchReference")
  expect_equal(length(res1), 13)
  expect_equal(length(res2), 13)
  expect_warning(search_reference(doi = c("10.2307/3225248", "ok")))
  expect_equal(res2$jstor, "3683041")
  expect_identical(resw, data.frame())
})


resc <- get_collection(res1)
test_that("get_collection", {
  expect_equal(class(resc), "mgNetwork")
  expect_identical(names(resc), nm_co)
})


res1 <- search_reference(doi = "Does not work")
