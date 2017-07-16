#' List installed packages
#'
#' @return list of installed packages
#' @export
#'
#' @examples
#' qls()
qls <- function() {
    # ret <- system("quilt ls", intern = T)
    # cat(ret, sep = "\n")
    cat_sys("quilt ls")
}


#' Search for packages by user or package name
#'
#' @param str user or package name
#'
#' @return list of matching packages
#' @export
#'
#' @examples
#' qsearch("akarve")
qsearch <- function(str) {
    cat_sys(paste("quilt search", str))
}

#' Peek at a data file
#'
#' Roughly equivalent to typing 'examples' in Python, i.e. the package name.
#'
#' @param str package name
#'
#' @return prints name of files
#' @export
#'
#' @examples
#' qpeek("akarve/examples")
qpeek <- function(str) {
    path <- paste0("~/quilt_packages/", str, ".json")
    package_info <- jsonlite::fromJSON(path)
    cat(names(temp$children), sep = "\n")
}

cat_sys <- function(x) {
    # little helper function for shell output
    cat(system(x, intern = T), sep = "\n")
}
