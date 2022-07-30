
#' Declare that a package is needed
#'
#' Declare that one or more packages are required by subsequent functionality,
#' and if they're missing, either prompt the user to install them, or exit with
#' an informative error message.
#'
#' @param ... Names of required packages, as character strings.
#' @param ask Whether to give the user the option of installing the required
#'   packages immediately.
#'
#' @return Invisibly, the names of any packages which were installed.
#'
#' @examples \dontrun{
#'
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
#'  }
#'
#' @export

need <- function(..., ask = interactive()) {

  pkgs <- sort(unlist(c(...)))

  loaded <- vapply(pkgs, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))

  # Nothing to do if all packages are already present!
  if (all(loaded))
    return(invisible(character()))

  message(
    "Additional packages are required to use this function: ",
    paste0(pkgs[!loaded], collapse = ", "),
    "\n"
  )


  if (isTRUE(ask))
    choice <- utils::menu(
      title = "Would you like to install these packages now?",
      choices = c("Yes", "No")
    )



  if (!isTRUE(ask) || choice != 1)
    stop(
      "Please install the following packages to use this function: ",
      "\n\n  install.packages(c(",
      paste0(dQuote(pkgs[!loaded], q = FALSE), collapse = ", "),
      "))",
      call. = FALSE
    )


  utils::install.packages(pkgs[!loaded])
  invisible(pkgs[!loaded])
}
