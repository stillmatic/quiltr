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
#' @param robust more robust data, natively parsed in R
#'
#' @return prints name of files
#' @export
#'
#' @examples
#' qpeek("akarve/examples")
#' qpeek("akarve/examples", TRUE)
qpeek <- function(str, robust=FALSE) {
    path <- paste0("~/quilt_packages/", str, ".json")
    if(!file.exists(path)) {
        stop("requested package not installed")
    }
    if(robust) {
        raw_json <- jsonlite::read_json(path)

        final_json <- raw_json %>%
            extract2("children") %>%
            toJSON

        df_json <- final_json %>%
            paste %>%
            gather_keys() %>%
            spread_values(
                hashes = jstring("hashes"),
                type = jstring("type")
            )
    } else {
        package_info <- jsonlite::fromJSON(path)
        cat(names(package_info$children), sep = "\n")
    }
}

#' helper function for shell output
#'
#' @param x command to run
#'
#' @return prints output of some command
#'
#' @examples
#' cat_sys("ls")
cat_sys <- function(x) {
    cat(system(x, intern = T), sep = "\n")
}
