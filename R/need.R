
#' Declare that packages are needed
#'
#' Declare that one or more packages are required by subsequent functionality;
#' and if they're missing, either prompt the user to install them, or exit with
#' an informative error message.
#'
#' @inheritParams is_installed
#' @param ... Names of required packages, as character strings. You can require
#'   a minimum version by appending `>=[version]` to a package name - see
#'   Examples.
#' @param msg Custom message to display; if `NULL`, an informative one will be
#'   constructed.
#' @param install_cmd Installation command to run, as a call (i.e. probably
#'   wrapped with [quote()] or [substitute()]). If `NULL`, [install.packages()]
#'   will be used for package installation.
#' @param ask Whether to give the user the option of installing the required
#'   packages immediately.
#'
#' @returns Invisibly, any package names from `...` which were installed.
#'
#' @examples
#' \dontrun{
#'   need("dplyr")
#'   need("dplyr", "tidyr")
#'
#'   # All unnamed arguments will be combined into one list of package names
#'   shared_deps <- c("dplyr", "tidyr")
#'   need(shared_deps, "stringr") # same as need("dplyr", "tidyr", "stringr")
#'
#'   # You can require a minimum version for some or all packages
#'   need("dplyr>=1.0.0", "tidyr")
#'
#'
#'   # Typically you'll want to use need() within a function
#'   read_data <- function(path, clean_names = FALSE) {
#'
#'     # Call need() as early as possible, to avoid wasted work
#'     if (isTRUE(clean_names))
#'       suggests::need("janitor")
#'
#'     output <- utils::read.csv(path)
#'
#'     if (isTRUE(clean_names))
#'       output <- janitor::clean_names(output)
#'
#'     output
#'   }
#'
#'
#'   # You can provide a custom message and/or installation command if needed
#'   need(
#'     "dplyr",
#'     msg = "We need the development version of dplyr, for now!",
#'     install_cmd = quote(remotes::install_github("tidyverse/dplyr"))
#'   )
#'
#' }
#'
#' @export
need <- function(
    ...,
    msg = NULL,
    install_cmd = NULL,
    ask = interactive(),
    load = FALSE,
    lib.loc = NULL
) {


  pkgs <- sort(unique(unlist(c(...))))

  installed <- is_installed(pkgs, load = load, lib.loc = lib.loc)

  # Nothing to do if all packages are already present!
  if (all(installed))
    return(invisible(character()))


  if (is.null(msg))
    msg <- paste(
      "To use this functionality, the following packages must be installed/updated:",
      sprintf("\n\n  %s", paste0(pkgs[!installed], collapse = ", "))
    )

  message(msg, "\n")

  if (isTRUE(ask))
    choice <- utils::menu(
      title = "Would you like to install/update now?",
      choices = c("Yes", "No")
    )


  # Default installation command, if a bespoke one wasn't provided
  if (is.null(install_cmd))
    # Not explicitly stating utils::install.packages() because we might have a
    # shim available e.g. from {renv}
    install_cmd <- substitute(install.packages(p), list(p = names(installed)[!installed]))


  if (!isTRUE(ask) || choice != 1)
    stop(
      "Please install/update packages to use this functionality:",
      sprintf("\n\n  %s", deparse(install_cmd)),
      call. = FALSE
    )

  eval(install_cmd)
  invisible(pkgs[!installed])
}
