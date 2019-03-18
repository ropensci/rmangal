#' List mangal datasets
#'
#' @param search `character` keyword to search (case sensitive).
#' @param ... arguments from [rmangal::get_gen()]
#' @return
#' object `data.frame`: Datasets with all networks and the original reference attached.
#' @examples
#' list_datasets()
#' list_datasets(search = "lagoon")
#' list_datasets(search = "2011")
#' @export

list_datasets <- function( search = NULL, ... ) {

    ellipsis <- list(...)
    
    # Allow custom query 
    if(!is.null(ellipsis$query)){
      query <- ellipsis$query
      ellipsis['query'] <- NULL
      message('Custom query mode')
    } else {
      query <- list( q = search )
    }

    datasets <- as.data.frame(get_gen(endpoints()$dataset,
      query = query, ... = ellipsis))

    if (!is.null(query)) {
      message(
      sprintf("Found %s dataset(s) for query: %s", nrow(datasets), query))
    } 

    # Attached reference and network
    networks <- list()
    references <- list()

    for(i in seq_len(nrow(datasets))) {
        networks[[i]] <- purrr::map_df(get_from_fkey(endpoints()$network,
          dataset_id = datasets[i,"id"]), "body")
        references[[i]] <- purrr::map_df(get_singletons(endpoints()$reference,
          ids =  datasets[i,"ref_id"], output = "data.frame"), "body")
    }

    if(nrow(datasets) > 0){
      datasets$networks <- networks
      datasets$references <-references
    }
    datasets

}
