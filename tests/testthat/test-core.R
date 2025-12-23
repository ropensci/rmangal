skip_if_not_installed("vcr")

test_that("rmangal_request() works", {
  expect_error(rmangal_request("wrong"), "Unknown endpoint")
  vcr::use_cassette(name = "rmangal_request", {
    lag <- rmangal_request(endpoint = "network", query = "lagoon")
    lag_hc <- rmangal_request(
      endpoint = "network",
      query = "Dietary matrix of the Huizache–Caimanero lagoon",
      cache = TRUE
    )
  })
  expect_true(inherits(lag, "mgGetResponses"))
  expect_identical(length(lag$body), 3L)
  expect_true(inherits(lag_hc, "mgGetResponses"))
  expect_identical(length(lag_hc$body), 1L)
})


test_that("rmangal_request_singleton() works", {
  expect_error(rmangal_request_singleton("wrong", 1), "Unknown endpoint")
  vcr::use_cassette(name = "rmangal_request_singleton", {
    net86 <- rmangal_request_singleton(endpoint = "network", id = 86)
  })
  expect_true(inherits(net86, "mgGetResponses"))
  expect_identical(length(net86$body), 1L)
})
