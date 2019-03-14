#' List of datasets with networks and reference attached
#'
#' @param ... arguments from [rmangal::get_gen()]
#' @return
#' @details
#' See endpoints available with `print(endpoints)`
#' @examples
#' listDatasets()
#' @export

listDatasets <- function( ... ) {

    datasets <- as.data.frame(get_gen(endpoints()$dataset), ...)
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

