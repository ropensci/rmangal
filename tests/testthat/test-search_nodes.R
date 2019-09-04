 context("test search_nodes")

res_acer <- search_nodes("Acer", verbose = FALSE)
res_926 <- search_nodes(list(network_id = 926), verbose = FALSE)
resw <- search_nodes("wrong", verbose = TRUE)


 test_that("expected behavior", {
   expect_true(all(dim(res_acer) == c(5, 18)))
   expect_true(all(class(res_acer) == c("data.frame", "mgSearchNodes")))
   expect_true(all(dim(res_926) == c(13, 18)))
   expect_identical(resw, data.frame())
 })


net_926 <- get_collection(res_926, verbose = FALSE)

test_that("expected behavior", {
  expect_equal(class(net_926), "mgNetwork")
  expect_true(all(names(net_926) == nm_co))
})
