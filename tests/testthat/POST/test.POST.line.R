# Those tests are for function mangal::POST_line

context("POST line")

#test_that("Warning for object that are not json data", {
#  expect_error(POST_line(c(1:5), "@@@"), "'table_lst_line' must be a json")
#})

data <- toJSON(cars[1,])

# How shall we test the injection of data without "disturbing" the database?

test_that("Connect to table", {
  expect_match(http_status(POST_line(data, "error"))[[3]], "404")
#  expect_match(http_status(POST_line("@@@", "@@@"))[[3]], "200")
})


