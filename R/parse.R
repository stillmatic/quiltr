#' Parse JSON specification to find info about a file
#'
#' @param pkg which package the file belongs to
#' @param file path to the file, see examples
#' @param package_path allows for user to set package location ("quilt_packages/" would set the location to the working directory)
#'
#' @return dataframe with info about a particular file
#' @export
#'
#' @import dplyr magrittr tidyjson
#' @examples
#' qparse("examples/wine", "quality/red")
#' qparse("akarve/seattle_911", "responses")
qparse <- function(pkg, file, package_path = "~/quilt_packages/") {
    path <- paste0(package_path, pkg, ".json")
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
