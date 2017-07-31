#' Push history
#'
#' @param str USER/PACKAGE
#'
#' @return push history of the package
#' @export
#'
#' @examples
#' qlog("akarve/examples")
qlog <- function(str) {
    system(paste0("quilt log ", str))
}

#' See versions of a package
#'
#' @param str USER/PACKAGE
#'
#' @return versions of the package
#' @export
#'
#' @examples
#' qversion("akarve/examples")
qversion <- function(str) {
    system(paste0("quilt version list ", str))
}
