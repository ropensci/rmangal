context("search_interactions")

res1 <- search_interactions(type = "competition")
res2 <- search_interactions(type = "competition", expand_node = TRUE)
res3 <- search_interactions(list(network_id = 926))
res4 <- search_interactions(list(network_id = 926), expand_node = TRUE)

test_that("expected behavior", {
  expect_identical(search_interactions("wrong"), data.frame())
  expect_equal(dim(res1), c(12, 19))
  expect_equal(class(res1), c("data.frame", "mgSearchInteractions"))
  expect_equal(class(res3), c("data.frame", "mgSearchInteractions"))
  # this may change if we merge data frames
  expect_equal(dim(res2), c(12, 55))
  expect_equal(dim(res3), c(34, 19))
  expect_true(all(res3$network_id == 926))
  expect_equal(dim(res4), c(34, 57))
  expect_true(all(res4$network_id == 926))
  expect_error(search_interactions(list(wrong = "wrong")))
  expect_warning(search_interactions(list(network_id = 926, wrong = "wrong")))
})


resc <- get_collection(res1)
test_that("get_collection", {
  expect_equal(class(resc), "mgNetworksCollection")
  expect_equal(class(resc[[1L]]), "mgNetwork")
  expect_equal(names(resc[[1L]]), nm_co)

})
