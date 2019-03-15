#' List of datasets with networks and reference attached
#'
#' @param search `character` keyword to search (case sensitive). 
#' @param ... arguments from [rmangal::get_gen()]
#' @return
#' object `data.frame`: Datasets with all networks and the original reference attached.
#' @details
#' See endpoints available with `print(endpoints)`
#' With `search` argument, the % can be used to represent any character or set of characters before or after the keyword (e.g '%lagoon%')
#' @examples
#' list_datasets()
#' list_datasets(search="%lagoon%")
#' @export

list_datasets <- function( search = NULL, ... ) {

    datasets <- as.data.frame(get_gen(endpoints()$dataset, query = list( q = search), ...))
    
    if(!is.null(search)) message(sprintf("Found %s dataset(s) for keywork: %s", nrow(datasets), search))

    # Attached reference and network
    networks <- list()
    references <- list()

    for(i in 1:nrow(datasets)){ 
        networks[[i]] <- purrr::map_df(get_fkey(endpoints()$network, column = "dataset_id", id = datasets[i,"id"]), "body")
        references[[i]] <- purrr::map_df(get_singletons(endpoints()$reference, ids =  datasets[i,"ref_id"], output = "data.frame"), "body")
    }

    datasets$networks <- networks
    datasets$references <- references

    return(datasets)

}

