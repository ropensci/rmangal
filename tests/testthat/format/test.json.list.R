# Those tests are for function mangal::json_list

context("Data frame to json list")

test_that("Warning of object other than data frame", {
  expect_error(json_list(c(1,2,3)), "'df' must be a data.frame")
})

data <- data.frame(matrix(data = c(1:50), ncol = 5, byrow = TRUE))

test_that("List is in json", {
  expect_is(json_list(data), "list")
  expect_equal(class((json_list(data))[[1]]), "json")
})

test_that("List and dataframe length equal", {
  expect_equal(length(json_list(data)), nrow(data))
})
