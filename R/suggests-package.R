#' @name suggests
#' @description
#'   By adding dependencies to the "Suggests" field of a package's
#'   DESCRIPTION file, and then declaring that they are needed within any
#'   dependent functionality, you can often significantly reduce the number of
#'   "hard" dependencies (i.e. Depends/Imports) required by your package.
#'
#'   {suggests} aims to make that workflow as minimal and painless as possible,
#'   primarily via the `need()` function, which provides a lightweight, simple,
#'   speedy way to prompt your users to install missing suggested packages.

#' @docType package
#' @keywords internal
"_PACKAGE"
