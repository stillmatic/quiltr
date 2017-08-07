#' Load file from Quilt
#'
#' @param pkg package name
#' @param file file name
#'
#' @return dataframe
#' @export
#'
#' @import reticulate
#' @examples
#' qload("akarve/examples", "README")
#' qload("examples/wine", "quality")
#' qload("examples/wine", "quality/red")
#' qload("akarve/seattle_911", "responses")
qload <- function(pkg, file) {
    info_df <- qparse(pkg, file)

    if(paste(info_df$class) != "TableNode") {
        stop("Not a TableNode")
    }

    pkg_pythonic <- stringr::str_replace_all(pkg, "/", "\\.")
    pkg_name <- paste0("quilt.data.", pkg_pythonic)
    data <- reticulate::import(module = pkg_name)
    file <- stringr::str_replace_all(file, "/", "$")

    df <- eval(parse(text = paste0("data$", file, "()")))
    tmp <- tempfile(pattern = "quilt", fileext = "feather")
    pyfeather <- reticulate::import(module = "feather")
    pyfeather$write_dataframe(df$copy(), tmp)
    feather::read_feather(tmp)
}
