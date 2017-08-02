#' Parse JSON specification to find info about a file
#'
#' @param pkg_name which package the file belongs to
#' @param file path to the file, see examples
#'
#' @return dataframe with info about a particular file
#' @export
#'
#' @import dplyr magrittr tidyjson reticulate
#' @examples
#' qparse("examples/wine", "quality/red")
#' qparse("akarve/seattle_911", "responses")
qparse <- function(pkg_name, file) {
    tools <- reticulate::import(module = "quilt.tools")
    stripped_pkg <- stringr::str_split(pkg_name, "/")[[1]]
    pkg <- tools$store$PackageStore$find_package(stripped_pkg[1], stripped_pkg[2])
    contents <- pkg$get_contents()

    # strip first layer of 'children'
    children <- contents$children

    # split the path
    nodes <- magrittr::extract2(stringr::str_split(file, "/"), 1)

    # traverse to second-lowest level
    if (length(nodes > 1)) {
        for (i in nodes[1:length(nodes) - 1]) {
            children <- children %>%
                magrittr::extract2(i) %>%
                magrittr::extract2("children")
        }
    }

    # find the final subtable
    final <- extract2(children, nodes[length(nodes)])

    # parse info about the file
    # TODO: make this more robust to non-table objects

    info <- dplyr::data_frame(
        name = paste(pkg, file),
        format = paste(final$format),
        hashes = final$hashes,
        json_type = final$json_type
    )

    if(format == "PackageFormat.HDF5") {
        # process HDF5
    } else if(format == "PackageFormat.PARQUET") {
        # process PARQUET
    }

    info
}
