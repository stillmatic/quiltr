#' Build
#'
#' @param pkg package to build
#' @param x data to build
#'
#' @return
#' @export
#'
#' @examples
#' data(iris)
#' qbuild("hua/iris", iris)
qbuild <- function(pkg, x) {
    quilt <- reticulate::import("quilt")
    pyfeather <- reticulate::import(module = "feather")

    tmp <- tempfile(pattern = "quilt", fileext = "feather")
    feather::write_feather(x, tmp)
    pdf <- pyfeather$read_dataframe(tmp)

    quilt$build(pkg, pdf)
}

qbuild_memory <- function(pkg, x) {
    quilt <- reticulate::import("quilt")
    pyfeather <- reticulate::import(module = "feather")

    # TODO: vectorize and accept multiple df's
    tmp_dir <- tempdir()
    tmp <- tempfile(pattern = "quilt", tmpdir = tmp_dir, fileext = "feather")
    feather::write_feather(x, tmp)
    pdf <- pyfeather$read_dataframe(tmp)

    quilt$build(pkg, pdf)
}

#' Push package from local to remote
#'
#' @param pkg package to push
#'
#' @return pushes package
#' @export
#'
#' @examples
qpush <- function(pkg) {
    quilt <- reticulate::import("quilt")
    quilt$push(pkg)
}
