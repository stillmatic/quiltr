#' Check if file exists
#'
#' @param path
#'
#' @return error if file doesn't exist
#'
#' @examples
check_file_exists <- function(path) {
    if (!file.exists(path)) {
        stop(sprintf("File at %s does not exist", path))
    }
}
