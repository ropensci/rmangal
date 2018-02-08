# Those tests are for function mangal::GET_fkey

context("GET foreing key")

test_that("Traps work", {
  expect_match(GET_fkey("users", "name", "XYZ"), "wrong attribute or value inexistant")
  # Prochain test ne fonctionne pas. Demander n<importe quel attribut envoi toute les entre...
  # expect_match(GET_fkey("users", "XYZ", "value"), "wrong attribute or value inexistant")
})

test_that("Get good key", {
  expect_match(GET_fkey("users", "name", "test1"), "1")
})
