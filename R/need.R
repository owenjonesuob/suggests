
#' Declare that a suggested package is required
#'
#' Declare that one or more packages are required by subsequent functionality,
#' and either prompt the user to install them, or exit with an informative
#' error message.
#'
#' @param ... Names of required packages, as character strings.
#' @param prompt Whether to give the user the option of installing the required
#'   packages immediately.
#'
#' @return Invisibly, the names of any packages which were installed.
#'
#' @examples
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
#'  }
#'
#' @export

need <- function(..., prompt = interactive()) {

  pkgs <- sort(unlist(c(...)))

  loaded <- vapply(pkgs, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))

  if (!all(loaded))
    message(
      "Additional packages are required to use this function:",
      "\n  ",
      paste0(pkgs[!loaded], collapse = ", ")
    )



  if (isTRUE(prompt))
    choice <- utils::menu(
      title = "Would you like to install these packages now?",
      choices = c("Yes", "No")
    )



  if (!isTRUE(prompt) || choice != 1)
    stop(
      "Please install the following packages to use this function: ",
      "\n\n  install.packages(c(",
      paste0(dQuote(pkgs[!loaded], q = FALSE), collapse = ", "),
      "))",
      call. = FALSE
    )


  install.packages(pkgs[!loaded])
  invisible(pkgs[!loaded])
}
