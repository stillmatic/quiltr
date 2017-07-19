# library(dplyr)
# library(tidyjson)
# temp <- tidyjson::read_json("~/quilt_packages/examples/wine.json")
# temp <- tidyjson::read_json("~/quilt_packages/akarve/examples.json")
# temp2 <- jsonlite::read_json("~/quilt_packages/akarve/examples.json")
#
# temp3 <- temp2 %>%
#     extract2("children") %>%
#     toJSON
#
# temp3 %>%
#     paste %>%
#     gather_keys() %>%
#     spread_values(
#         hashes = jstring("hashes"),
#         type = jstring("type")
#     ) %>%
#     filter(key == "sales")

#' Parse JSON specification to find info about a file
#'
#' @param pkg
#' @param file
#'
#' @return
#' @export
#'
#' @import dplyr magrittr tidyjson
#' @examples
qparse <- function(pkg, file) {
    # check_package(pkg, file)

    path <- paste0("~/quilt_packages/", pkg, ".json")

    raw_json <- jsonlite::read_json(path)

    final_json <- raw_json %>%
        extract2("children") %>%
        toJSON

    df_json <- final_json %>%
        paste %>%
        gather_keys() %>%
        spread_values(
            hashes = jstring("hashes"),
            type = jstring("type")
        )

    if(file %in% df_json$key) {
        hash <- df_json %>%
            filter(key == file) %$%
            hashes
        if(is.na(hash)) {
            stop("must go a layer deeper")
        } else {
            return(hash)
        }
    } else {
        stop("file not in package")
    }
}
# qparse("examples/wine", "quality")

