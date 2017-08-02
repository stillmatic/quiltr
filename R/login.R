#' Login to Quilt (web interface)
#'
#' @param quilt_url change if you have a separate Quilt package manager installation
#'
#' @return save auth and logs in
#' @export
#'
#' @examples
#' \dontrun{qlogin()}
qlogin <- function(quilt_url = 'https://pkg.quiltdata.com') {
    # QUILT_PKG_URL = os.environ.get('QUILT_PKG_URL', DEFAULT_QUILT_PKG_URL)
    quilt <- reticulate::import("quilt")
    login_url <- sprintf("%s/login", quilt_url)
    browseURL(login_url)
    refresh_token <- readline("Enter the code from the page: ")
    # hacky stuff follows - names shouldn't start with underscores in R
    auth <- eval(parse(
        text = paste("quilt$tools$command$_update_auth(refresh_token)")))
    eval(parse(
        text = paste("quilt$tools$command$_save_auth(auth)")
    ))
    eval(parse(
        text = paste("quilt$tools$command$_clear_session()")
    ))
}
