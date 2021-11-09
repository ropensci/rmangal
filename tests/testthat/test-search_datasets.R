# number of variables (columns)
nvr <- 10

test_that("search_datasets() query and collection work", {
  vcr::use_cassette(name = "search_datasets_default", {
    res1 <- search_datasets(query = "lagoon")
    resc <- get_collection(res1)
  })
  expect_equal(dim(res1), c(2, nvr))
  expect_equal(class(resc), "mgNetworksCollection")
  expect_equal(class(resc[[1L]]), "mgNetwork")
  # at least one network per dataset
  expect_true(length(resc) >= nrow(res1))
  expect_equal(names(resc[[1L]]), nm_co)
})

test_that("search_datasets() bad input format", {
  expect_error(
    search_datasets(query = 2011), 
    regex = "a list or a character string\\.$")
})

test_that("search_datasets() querying via list works", {
  vcr::use_cassette(name = "search_datasets_list", {
    res <- search_datasets(query = list(name = "kemp_1977"))
  })
  expect_s3_class(res, "mgSearchDatasets")
  expect_equal(dim(res), c(1, nvr))
})

test_that("search_datasets() no match works", {
  vcr::use_cassette(name = "search_datasets_empty", {
    expect_message(res <- search_datasets(query = "does not exist"))
  })
  expect_s3_class(res, "data.frame")
  expect_equal(dim(res), c(0, 0))
})


