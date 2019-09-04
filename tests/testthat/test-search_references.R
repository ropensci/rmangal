context("test search_references")

res1 <- search_references(doi = "10.2307/3225248")
res2 <- search_references(list(jstor = 3683041))
res3 <- suppressWarnings(search_references(doi = c("10.2307/3225248", "ok")))
res4 <- search_references(list(year = 2010))
resw <- search_references("wrong")

test_that("expected behavior", {
  expect_error(search_references())
  expect_equal(class(res1), "mgSearchReferences")
  expect_equal(length(res1), 13)
  expect_equal(length(res2), 13)
  expect_equal(length(res4), 13)
  expect_equal(length(res4$network), 5)
  expect_warning(search_references(doi = c("10.2307/3225248", "ok")))
  expect_equal(res2$jstor, "3683041")
  expect_identical(resw, data.frame())
})


resc <- get_collection(res1)
test_that("get_collection", {
  expect_equal(class(resc), "mgNetwork")
  expect_identical(names(resc), nm_co)
})


res1 <- search_references(doi = "Does not work")
