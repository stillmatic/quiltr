#' Login to Quilt (web interface)
#'
#' This function helps you get a OAuth Token from your Quilt installation and
#' then stores it, along with some other data, in a `auth.json` file.
#'
#' @param quilt_url change if you have a separate Quilt package manager installation
#'
#' @md
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
    quilt$login_with_token(refresh_token)
}

#' Log out of Quilt
#'
#' @return Deletes your saved auth info
#' @export
#'
#' @examples
#' \dontrun{qlogout()}
qlogout <- function() {
    quilt <- reticulate::import("quilt")
    quilt$logout()
}
