#' Parse JSON specification to find info about a file
#'
#' @param pkg which package the file belongs to
#' @param file path to the file, see examples
#'
#' @return dataframe with info about a particular file
#' @export
#'
#' @import dplyr magrittr tidyjson
#' @examples
#' qparse("examples/wine", "quality/red")
#' qparse("akarve/seattle_911", "responses")
qparse <- function(pkg, file) {
    # check_package(pkg, file)

    path <- paste0("~/quilt_packages/", pkg, ".json")
    check_file_exists(path) # TODO: assertr?
    raw_json <- jsonlite::read_json(path)

    # strip first layer of 'children'
    final_json <- raw_json %>%
        magrittr::extract2("children") %>%
        jsonlite::toJSON() %>%
        paste

    # split the path
    nodes <- stringr::str_split(file, "/") %>%
        extract2(1)

    # traverse to second-lowest level
    if (length(nodes > 1)) {
        for (i in nodes[1:length(nodes) - 1]) {
            final_json <- final_json %>%
                enter_object(nodes[1]) %>%
                enter_object("children")
        }
    }

    # find the final subtable
    final_path <- nodes[length(nodes)]
    df_json <- final_json %>%
        gather_keys() %>%
        spread_values(
            format = jstring("format"),
            hashes = jstring("hashes"),
            type = jstring("type")
        ) %>%
        filter(key == final_path)
    df_json
}

