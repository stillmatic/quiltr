#' Build a package
#'
#' @param pkg package to build
#' @param x data to build
#'
#' @return builds the package
#' @export
#'
#' @examples
#' data(iris)
#' qbuild("hua/iris", iris = iris)
qbuild <- function(pkg, ...) {
    quilt <- reticulate::import("quilt")
    pyfeather <- reticulate::import(module = "feather")

    pkg_split <- stringr::str_split(pkg, "/")[[1]]

    store <- reticulate::import("quilt.tools.store")
    pkg_obj <- store$PackageStore$find_package(pkg_split[1], pkg_split[2])
    # if(!is.null(pkg_obj)) {
        # pkg_path <- pkg_obj.get_path()
    # } else {
        # pkg_path <- tempdir()
        # pkg_path <- paste0(getwd(), "/quilt_packages")
    # }

    # create temp dir to build the package with
    pkg_path <- paste0(tempdir(), "/", pkg_split[2])
    if(!dir.exists(pkg_path))
        dir.create(pkg_path)

    # write each file to the temp dir
    files <- list(...)
    for(i in 1:length(files)) {
        file_name <- names(files)[i]
        file_path <- paste0(pkg_path, "/", file_name)
        if(tolower(tools::file_ext(file_name)) != "") {
            writeLines(text = paste(files[i]), con = file_path)
        } else {
            write.csv(files[i], file = file_path)
        }
    }
    quilt$build(pkg, pkg_path)

    # unlink(pkg_path, recursive = TRUE)
}

#' Push package from local to remote
#'
#' @param pkg package to push
#' @param public if the package is public or not
#' @param reupload
#'
#' @return pushes package
#' @export
#'
#' @examples
#' qpush("hua/test", TRUE)
qpush <- function(pkg, public = FALSE, reupload = FALSE) {
    quilt <- reticulate::import("quilt")
    quilt$push(pkg, public, reupload)
}
