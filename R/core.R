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
#' @param str package name
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
qpeek <- function(str, robust=FALSE) {
    path <- paste0("~/quilt_packages/", str, ".json")
    path <- path.expand(path)
    if (!file.exists(path)) {
        stop("requested package not installed")
    }
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
    if(!is.null(hash)) {
        cmd <- paste(cmd, "-x", hash)
    }
    if(!is.null(version)) {
        cmd <- paste(cmd, "-v", version)
    }
    if(!is.null(tag)) {
        cmd <- paste(cmd, "-t", tag)
    }
    ret <- system(cmd, intern = T)
    return(ret)
}

#' helper function for shell output
#'
#' @param x command to run
#'
#' @return prints output of some command
#'
cat_sys <- function(x) {
    cat(system(x, intern = T), sep = "\n")
}
