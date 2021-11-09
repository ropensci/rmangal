library(vcr)
vcr::vcr_configure(dir = "../fixtures", write_disk_path = "../files")

rmangal::clear_cache_rmangal()
cl_df <- c("tbl_df", "tbl",  "data.frame")
nm_co <-  c("network", "nodes", "interactions", "dataset", "reference")
