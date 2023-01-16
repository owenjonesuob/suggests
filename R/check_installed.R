
#' Check whether packages are installed
#'
#' If `load = FALSE`, check whether a folder for the package exists in any of
#' the specified libraries. Much faster, but less robust!
#'
#' If `load = TRUE`, try to load the namespace of each package in turn; this is
#' slower, but less likely to return incorrect results.
#'
#' @param pkgs Character vector of package names to check.
#' @param load Whether to make sure the packages can be loaded.
#' @param lib.loc Library locations to check, [.libPaths()] by default.
#'
#' @export

check_installed <- function(pkgs, load = FALSE, lib.loc = .libPaths()) {

  is_installed <- if (isTRUE(load)) {

    vapply(pkgs, requireNamespace, quietly = TRUE, lib.loc = lib.loc, FUN.VALUE = logical(1))

  } else {

    # Check whether package folder exists, in each library
    is_in_lib <- lapply(
      lib.loc,
      function(lib) file.exists(file.path(lib, pkgs))
    )

    # If folder exists in *any* library, return TRUE for that package
    as.logical(.mapply(max, is_in_lib, list()))
  }

  names(is_installed) <- pkgs
  is_installed
}
