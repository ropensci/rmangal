# Those tests are for function mangal::POST_table

context("POST table")

dataA <- (cars[1:3,])

dataB <- data.frame(name = c("test1", "test2"))
dataB[,2] <- c(1:2)
colnames(dataB) <- c("name", "id")
dataB <- json_list(dataB)


test_that("Status of the request is store", {
  expect_output(POST_table(dataB, "users"), "No entry failed")
  expect_match(POST_table(dataB, "users"), "(400)")
  expect_match(POST_table(dataB, "error"), "(404)")
})

test_that("Fail if not a list", {
  expect_error(POST_table(dataA, "users"), "data_lst must be a list")
})
