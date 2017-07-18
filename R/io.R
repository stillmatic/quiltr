#' Load file from Quilt
#'
#' @param pkg package name
#' @param file file name
#'
#' @return dataframe
#' @export
#'
#' @examples
#' qload("akarve/examples", "sales") %>% head
#' qload("akarve/examples", "README")
#' qload("examples/wine", "quality")
#' qload("examples/wine", "quality/red")
qload <- function(pkg, file) {
    path <- paste0("~/quilt_packages/", pkg, ".json")

    if(!(file.exists(path))) {
        stop(sprintf("package '%s' not found in local installation", pkg))
    }

    package_info <- jsonlite::fromJSON(path)

    nodes <- stringr::str_split(file, "/")

    if(!(file %in% names(package_info$children))) {
        stop(sprintf("file '%s' not found in package", file))
    }

    file_info <- magrittr::extract2(package_info$children, file)

    if(!("hashes" %in% names(file_info))) {
        stop("file not found - probably a collection, go another level deeper.")
    }

    hash <- package_info$children %>%
        magrittr::extract2(file) %>%
        magrittr::extract2("hashes")

    type <- package_info$children %>%
        magrittr::extract2(file) %>%
        magrittr::extract2("type")

    if(!(hash %in% dir("~/quilt_packages/objs"))) {
        stop("file valid but hash missing from disk")
    }

    hash_path <- paste0("~/quilt_packages/objs/", hash)

    if(type == "TABLE") {
        return(read_hdf5(hash_path))
    }

    if(type == "FILE") {
        cat(hash_path)
        # cat(readChar(hash_path, file.info(hash_path)$size))
        return(readr::read_file(hash_path))
    }

    stop("Requested file is currently not supported by quiltR")

    # sc <- sparklyr::spark_connect(master = "local")
    # df <- sparklyr::spark_read_parquet(sc, file, hash_path)
    # sq <- SparkR::sparkRSQL.init(sc)
    # df <- SparkR::collect(SparkR::parquetFile(sq, hash_path))
    # SparkR::sparkR.stop()
    # df
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

