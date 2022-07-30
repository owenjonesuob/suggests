#' Annoyingly return the median of the first 10 elements of a vector
#'
#' @param data A dataframe.
#'
#' @importFrom utils head tail
#' @importFrom tools toTitleCase
#' @import tools
#'
#' @export

median_first_ten <- function(x) {

  first_ten <- head(x, 10)

  print(toTitleCase("hello there"))

  stats::median(first_ten)
}
