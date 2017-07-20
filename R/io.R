check_package <- function(pkg, file = NULL) {
    path <- paste0("~/quilt_packages/", pkg, ".json")

    if(!(file.exists(path))) {
        stop(sprintf("package '%s' not found in local installation", pkg))
    }

    package_info <- jsonlite::fromJSON(path)

    nodes <- stringr::str_split(file, "/")

    if(!(file %in% names(package_info$children))) {
        stop(sprintf("file '%s' not found in package", file))
    }
}

#' Load file from Quilt
#'
#' @param pkg package name
#' @param file file name
#'
#' @return dataframe
#' @export
#'
#' @examples
#' head(qload("akarve/examples", "sales"))
#' qload("akarve/examples", "README")
#' qload("examples/wine", "quality")
#' qload("examples/wine", "quality/red")
#' qload("akarve/seattle_911", "responses")
qload <- function(pkg, file) {
    # check_package(pkg, file)

    info_df <- qparse(pkg, file)

    type <- stringr::str_extract(info_df$type[[1]], "([A-Z0-9])\\w+")
    hash <- stringr::str_extract(info_df$hash[[1]], "([A-Z0-9])\\w+")
    qformat <- stringr::str_extract(info_df$format[[1]], "([A-Z0-9])\\w+")

    if(qformat == "PARQUET") {
        sc <- sparklyr::spark_connect(master = "local")
        df <- sparklyr::spark_read_parquet(sc, file, hash)
        sq <- SparkR::sparkRSQL.init(sc)
        df <- SparkR::collect(SparkR::parquetFile(sq, hash))
        SparkR::sparkR.stop()
        df
    }

    if(type == "TABLE") {
        return(read_hdf5(hash))
    }

    if(type == "FILE") {
        return(readr::read_file(hash))
    }

    stop("Requested file is currently not supported by quiltR")
}

#' Read HDF5 data
#'
#' Helper function from [joschkazj](https://github.com/pandas-dev/pandas/issues/9636)
#' Legacy support only. Modern files are Parquet only.
#'
#' @param h5File
#'
#' @return data frame
#' @export
#' @md
#'
#' @examples
read_hdf5 <- function(h5File) {
    listing <- rhdf5::h5ls(h5File)
    # Find all data nodes, values are stored in *_values and corresponding column
    # titles in *_items
    data_nodes <- grep("_values", listing$name)
    name_nodes <- grep("_items", listing$name)

    data_paths = paste(listing$group[data_nodes], listing$name[data_nodes], sep = "/")
    name_paths = paste(listing$group[name_nodes], listing$name[name_nodes], sep = "/")

    columns = list()
    for (idx in seq(data_paths)) {
        data <- data.frame(t(rhdf5::h5read(h5File, data_paths[idx])))
        names <- t(rhdf5::h5read(h5File, name_paths[idx]))
        entry <- data.frame(data)
        colnames(entry) <- names
        columns <- append(columns, entry)
    }

    data <- data.frame(columns)

    return(data)
}

read_parquet <- function() {

}
