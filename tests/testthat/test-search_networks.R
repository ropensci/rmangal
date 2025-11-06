test_that("search_networks() default and collection work", {
  vcr::use_cassette(name = "search_networks_def", {
    res1 <- search_networks("lagoon")
    resc <- get_collection(res1)
  })
  expect_equal(nrow(res1), 3)
  expect_s3_class(res1, "mgSearchNetworks")
  expect_equal(class(resc), "mgNetworksCollection")
  expect_equal(class(resc[[1L]]), "mgNetwork")
  # at least one network per dataset
  expect_true(length(resc) == nrow(res1))
  expect_equal(names(resc[[1L]]), nm_co)
  expect_snapshot(res1)
})

test_that("search_networks_sf() spatial queries work", {
  vcr::use_cassette(name = "search_networks_spat", {
    # search_networks_sf() gets all ids, will keep growing
    # at some point the yaml might get too heavy
    area <- system.file("shape/nc.shp", package = "sf") |>
      sf::st_read(quiet = TRUE)
    res <- search_networks_sf(area)
    # resc <- get_collection(res1) # don't think it's needed
  })
  expect_s3_class(res, "mgSearchNetworks")
  expect_s3_class(res, "sf")
  expect_equal(nrow(res), 5)
})

test_that("search_networks() handles 404", {
  vcr::use_cassette(name = "search_networks_404", {
    expect_snapshot(res1 <- search_networks(query = "this_is_wrong"))
  })
  expect_identical(res1, data.frame())
})
