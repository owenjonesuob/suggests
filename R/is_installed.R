
#' Check whether packages are installed
#'
#' @description
#' Initially, [utils::packageVersion()] is used to try to retrieve a version
#' from a package's `DESCRIPTION` file. This is a fast method, but doesn't
#' categorically guarantee that the package is actually available to use.
#'
#' If `load = TRUE`, then [base::requireNamespace()] is used to try to load the
#' namespace of each package in turn. This is much slower, but is the closest we
#' can get to ensuring that the package is genuinely usable.
#'
#' @param pkgs A character vector of package names. You can check for a minimum
#'   version by appending `>=[version]` to a package name - see Examples.
#' @param load Whether to make sure packages can be loaded - significantly
#'   slower, but gives an extra level of certainty.
#' @param lib.loc Passed to [utils::packageVersion()].
#'
#' @returns A logical vector of the same length as `pkgs`, where each element is
#'   `TRUE` if the package is installed, and `FALSE` otherwise.
#'
#' @examples
#'   is_installed("base")
#'   is_installed(c("base", "utils"))
#'
#'   is_installed("base>=3.0.0")
#'   is_installed(c(
#'     "base>=3.0.0",
#'     "utils"
#'   ))
#'
#' @export
is_installed <- function(pkgs, load = FALSE, lib.loc = NULL) {

  pkgs_vers <- strsplit(pkgs, "\\s*>=\\s*")

  pkgs <- vapply(
    pkgs_vers,
    function(x) x[[1]],
    character(1)
  )

  vers <- package_version(vapply(
    pkgs_vers,
    function(x) if (length(x) == 2) x[[2]] else "0.0", # minimum possible valid version
    character(1)
  ))


  mapply(
    function(pkg, ver) isTRUE(try(

      # Package is installed (otherwise, error!) and has sufficiently high version
      (utils::packageVersion(pkg, lib.loc = lib.loc) >= ver) &&
        # Package can be loaded (if this was requested)
        (if (isTRUE(load)) requireNamespace(pkg, quietly = TRUE) else TRUE),

      silent = TRUE
    )),
    pkgs,
    vers
  )
}
