#' Clear memoise cache
#' 
#' Resets the cache of the memoised function used for http GET queries (see [memoise::forget()]).
#' 
#' @export
#'
#' @return
#' `TRUE` when the cache has been reset. 
#' 
#' @examples
#' clear_cache_rmangal()

clear_cache_rmangal <- function() {
  # mem_get() is  a memoise function around
  # [httr::GET()] used in `get_gen` in `get_singleton` (see zzzR)
  memoise::forget(mem_get)
}
