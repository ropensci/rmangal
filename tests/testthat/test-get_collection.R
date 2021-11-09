test_that("get_collection() queries by id work", {
  vcr::use_cassette(name = "get_collection_id", {
    res0 <- get_collection(c(1035:1036))
  })
  expect_equal(res0[[1]]$network$network_id, 1035)
  expect_s3_class(res0, "mgNetworksCollection")
  expect_equal(length(res0), 2)
}
)

## NB: other methods for get_collection() are tested in other files to 
## avoid repeating several request


test_that("get_collection(NULL) returns an empty dataframe", {
  expect_warning(get_collection(NULL))
  expect_identical(suppressWarnings(get_collection(NULL)), data.frame())
}
)

test_that("get_collection() expected errors", {
  vcr::use_cassette(name = "get_collection_errors", {
    expect_error(suppressWarnings(get_collection("hh")))
  })
})

