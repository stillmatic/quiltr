#' Push history
#'
#' @param str USER/PACKAGE
#'
#' @return
#' @export
#'
#' @examples
#' qlog("akarve/examples")
qlog <- function(str) {
    cat_sys(paste0("quilt log ", str))
}

#' See versions of a package
#'
#' @param str
#'
#' @return
#' @export
#'
#' @examples
#' qversion("akarve/examples")
qversion <- function(str) {
    cat_sys(paste0("quilt version list ", str))
}

