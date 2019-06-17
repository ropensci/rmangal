context("get_citation")

ref <- get_citation(get_network_by_id(18))
netws <- get_collection(search_networks("lagoon"))
ref2 <- get_citation(netws)


test_that("expected behavior", {
  expect_equal(length(ref), 1)
  expect_equal(length(ref2), 2)
  expect_true(grepl("^@article", ref))
  expect_true(grepl("^@article", ref2[1]))
  expect_true(grepl("^@book", ref2[2]))
})
