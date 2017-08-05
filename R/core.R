#' List installed packages
#'
#' @return list of installed packages
#' @export
#'
#' @examples
#' qls()
qls <- function() {
    ret <- system("quilt ls", intern = T)
    return(ret)
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
    ret <- system(paste("quilt search", str), intern = T)
    return(ret)
}

#' Peek at a data file
#'
#' Roughly equivalent to typing 'examples' in Python, i.e. the package name.
#'
#' @param pkg package name
#' @param robust more robust data, natively parsed in R
#'
#' @return prints name of files
#' @export
#'
#' @import dplyr tidyjson
#'
#' @examples
#' qpeek("akarve/examples")
#' qpeek("akarve/examples", TRUE)
qpeek <- function(pkg, robust=FALSE) {
    pkg_split <- stringr::str_split(pkg, "/")[[1]]
    store <- reticulate::import("quilt.tools.store")
    pkg_obj <- store$PackageStore$find_package(pkg_split[1], pkg_split[2])
    if(is.null(pkg_obj)) {
        stop("Package not installed")
    }
    path <- pkg_obj$get_path()

    if (robust) {
        # TODO: integrate with parse
        raw_json <- jsonlite::read_json(path)

        final_json <- raw_json %>%
            magrittr::extract2("children") %>%
            jsonlite::toJSON

        df_json <- final_json %>%
            paste %>%
            tidyjson::gather_keys() %>%
            tidyjson::spread_values(
                format = tidyjson::jstring("format"),
                hashes = tidyjson::jstring("hashes"),
                type = tidyjson::jstring("type")
            ) %>%
            dplyr::select(-document.id)
        return(df_json)
    } else {
        package_info <- jsonlite::fromJSON(path)
        cat(names(package_info$children), sep = "\n")
    }
}

#' Install a Quilt package
#'
#' @param pkg user/package name to install
#' @param hash optional
#' @param version optional
#' @param tag optional
#'
#' @return nothing, installs specified file
#' @export
#'
#' @examples
#' \dontrun{qinstall('akarve/examples')}
qinstall <- function(pkg, hash = NULL, version = NULL, tag = NULL) {
    cmd <- sprintf("quilt install %s", pkg)
    if (!is.null(hash)) {
        cmd <- paste(cmd, "-x", hash)
    }
    if (!is.null(version)) {
        cmd <- paste(cmd, "-v", version)
    }
    if (!is.null(tag)) {
        cmd <- paste(cmd, "-t", tag)
    }
    ret <- system(cmd, intern = T)
    return(ret)
}


