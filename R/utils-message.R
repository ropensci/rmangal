#' Messages Utils 
#' 
#' @noRd 

# message
rmangal_inform <- function(..., .envir = parent.frame()) {
    is_verbose_mode <- getOption("rmangal.verbose", "verbose") == "verbose"
    if (is_verbose_mode) {
        # Options local to this function only; reset on exit!
        rlang::local_options(rlib_message_verbosity = "verbose")
        cli::cli_inform(..., .envir = .envir)
    }
}

percent_id <- function(y) round(100 * sum(!is.na(y)) / length(y))

print_taxo_ids <- function(x) {
    cli::cli_text(
        "{cli::symbol$bullet} Taxonomic IDs coverage for nodes:"
    )
    cli::cli_text(
        "{cli::col_cyan('ITIS')}: {percent_id(x$taxonomy.tsn)}%, ",
        "{cli::col_cyan('BOLD')}: {percent_id(x$taxonomy.bold)}%, ",
        "{cli::col_cyan('EOL')}: {percent_id(x$taxonomy.eol)}%, ",
        "{cli::col_cyan('COL')}: {percent_id(x$taxonomy.col)}%, ",
        "{cli::col_cyan('GBIF')}: {percent_id(x$taxonomy.gbif)}%, ",
        "{cli::col_cyan('NCBI')}: {percent_id(x$taxonomy.ncbi)}%"
    )
    invisible()
}

print_pub_info <- function(x) {
    cli::cli_text(
        "{cli::symbol$bullet} Published in reference #{cli::col_blue(x$id)} ",
        "DOI: {cli::col_grey(x$doi)}"
    )
    invisible()
}

print_net_info <- function(
  net_id, dat_id, descr, n_edg, n_nod, .envir = parent.frame()
) {
    cli::cli_h3(
        "Network #{cli::col_blue(net_id)}"
    )
    cli::cli_ul()
    cli::cli_li("Dataset: #{cli::col_blue(dat_id)}")
    cli::cli_li("Description: {descr}")
    cli::cli_li(
        "Size: {cli::pluralize('{n_edg} edge{?s}') |> cli::col_green()}, 
        {cli::pluralize('{n_nod} node{?s}') |> cli::col_green()}"
    )
    cli::cli_end()
    invisible()
}
