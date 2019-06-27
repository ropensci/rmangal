context("helpers")

df <- data.frame(
    taxonomy.tsn = c(1,2),
    taxonomy.bold = c(1,2),
    taxonomy.col = c(1,2),
    taxonomy.eol = c(1,NA),
    taxonomy.gbif = c(1,2),
    taxonomy.ncbi = c(1,2)
)

txt0 <- "* Percent of nodes with taxonomic IDs from external sources: \n  --> "
txt1 <- "100% ITIS, 100% BOLD, 50% EOL, 100% COL, 100% GBIF, 100% NCBI\n"

test_that("expected behavior", {
  expect_equal(percent_id(df$taxonomy.eol), 50)
  expect_equal(print_taxo_ids(df), paste0(txt0, txt1))
}
)
