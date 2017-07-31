

check_package <- function(pkg, file = NULL, package_path = "~/quilt_packages/") {
    path <- paste0(package_path, pkg, ".json")

    if (!(file.exists(path))) {
        stop(sprintf("package '%s' not found in local installation", pkg))
    }

    package_info <- jsonlite::fromJSON(path)

    if (!(file %in% names(package_info$children))) {
        stop(sprintf("file '%s' not found in package", file))
    }
}

#' Load file from Quilt
#'
#' @param pkg package name
#' @param file file name
#' @param file_type flip between feather or csv file as the intermediary betwen parquet and R
#' @param package_path allows for user to set package location ("quilt_packages/" would set the location to the working directory)
#'
#' @return dataframe
#' @export
#'
#' @examples
#' qload("akarve/examples", "README")
#' qload("examples/wine", "quality")
#' qload("examples/wine", "quality/red")
#' qload("akarve/seattle_911", "responses")
qload <- function(pkg, file, file_type = "feather", package_path = "~/quilt_packages/") {
    info_df <- qparse(pkg, file)

    type <- stringr::str_extract(info_df$type[[1]], "([A-Z0-9])\\w+")
    hash <- stringr::str_extract(info_df$hash[[1]], "([A-Z0-9])\\w+")
    qformat <- stringr::str_extract(info_df$format[[1]], "([A-Z0-9])\\w+")

    if (qformat == "PARQUET") {
        return(read_parquet(paste0(paste0(package_path, "objs/"), hash), file_type))
    }

    if (type == "TABLE") {
        return(read_hdf5(hash))
    }

    if (type == "FILE") {
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
    # Find all data nodes, values are stored in *_values and corresponding
    # column titles in *_items
    data_nodes <- grep("_values", listing$name)
    name_nodes <- grep("_items", listing$name)

    data_paths <- paste(listing$group[data_nodes], listing$name[data_nodes],
                       sep = "/")
    name_paths <- paste(listing$group[name_nodes], listing$name[name_nodes],
                       sep = "/")

    columns <- list()
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

#' Read parquet files
#'
#' For now, creates a CSV file and reads that instead.
#'
#' @param file_path path to file
#' @param file_type flip between feather or csv file as the intermediary betwen parquet and R
#' @param suppress if TRUE supresses warnings associated with loading csv and feather format files
#'
#' @return
#' @export
#'
#' @examples
read_parquet <- function(file_path, file_type = "feather", suppress = TRUE) {
    if ((file_type != "feather") & (file_type != "csv")) {
        stop('file_type must be set to either "feather" or "csv".')
    }
    stopifnot(file.exists(file_path))
    file_path <- path.expand(file_path)
    if (file_type == "feather") {
        feather_path <- paste0(file_path, ".feather")
        if (!file.exists(feather_path)) {
            cmd <- paste0("python -c ", "'", 'import pyarrow.parquet as pq; import sys; import feather; table = pq.read_table(sys.argv[1]); df = table.to_pandas(); feather.write_dataframe(df, sys.argv[1] + ".feather")',
                          "' ", '"', file_path, '"')
            system(cmd)
        }
        if (suppress) {
            oldw <- getOption("warn")
            options(warn = -1)
            df <- feather::read_feather(feather_path)
            options(warn = oldw)
        } else {
            df <- feather::read_feather(feather_path)
        }
    } else if (file_type == "csv") {
        csv_path <- paste0(file_path, ".csv")
        if (!file.exists(csv_path)) {
            cmd <- paste0("python -c ", "'", 'import pyarrow.parquet as pq; import sys; table = pq.read_table(sys.argv[1]); df = table.to_pandas(); df.to_csv(sys.argv[1] + ".csv", index=False, index_label=False)',
                          "' ", '"', file_path, '"')
            system(cmd)
        }
        if (suppress) {
            oldw <- getOption("warn")
            options(warn = -1)
            df <- readr::read_csv(csv_path, progress = FALSE)
            options(warn = oldw)
        } else {
            df <- readr::read_csv(csv_path, progress = FALSE)
        }
    }

    return(df)
}
