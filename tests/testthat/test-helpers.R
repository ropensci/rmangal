context("helpers")

df <- data.frame(
    taxonomy.tsn = c(1,2),
    taxonomy.bold = c(1,2),
    taxonomy.col = c(1,2),
    taxonomy.eol = c(1,NA),
    taxonomy.gbif = c(1,2),
    taxonomy.ncbi = c(1,2)
)

txt0 <- "* Current taxonomic IDs coverage for nodes of this network: \n  --> "
txt1 <- "ITIS: 100%, BOLD: 100%, EOL: 50%, COL: 100%, GBIF: 100%, NCBI: 100%\n"

test_that("expected behavior", {
  expect_equal(percent_id(df$taxonomy.eol), 50)
  expect_equal(print_taxo_ids(df), paste0(txt0, txt1))
  expect_true(clear_cache_rmangal())
}
)
