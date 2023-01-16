# suggests: Declare when Suggested Packages are Needed

<!-- badges: start -->
[![R-CMD-check](https://github.com/owenjonesuob/suggests/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/owenjonesuob/suggests/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/owenjonesuob/suggests/branch/main/graph/badge.svg)](https://app.codecov.io/gh/owenjonesuob/suggests?branch=main)
<!-- badges: end -->

By adding dependencies to the "Suggests" field of a package's DESCRIPTION file, and then declaring that they are needed within any dependent functionality, it is often possible to significantly reduce the number of "hard" dependencies (i.e. Depends/Imports) required by a package.

This package aims to make that workflow as painless as possible, primarily via the `need()` function, which provides a compact interface to the approach suggested here: <https://r-pkgs.org/dependencies.html>


## Installation

You can install the development version of suggests from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("owenjonesuob/suggests")
```

Or directly from [R-universe](https://r-universe.dev/):
```r
install.packages("suggests", repos = "https://owenjonesuob.r-universe.dev")
```

## Usage

You can declare that one or more packages are needed for subsequent functionality with `need()`:

``` r
 read_data <- function(path, clean_names = FALSE) {

   # Call suggests::need() as early as possible, to avoid wasted work
   if (isTRUE(clean_names))
     suggests::need("janitor")

   output <- utils::read.csv(path)

   if (isTRUE(clean_names))
     output <- janitor::clean_names(output)

   output
 }
```

Additionally, `find_pkgs()` is a quick-and-dirty diagnostic tool to find dependency usage within top-level expressions (e.g. declared functions) in R scripts within a development package. This can be useful when looking for good candidates for dependencies which could be moved from `Imports` to `Suggests` in the `DESCRIPTION` file.

Given a path, it returns a data frame with one row per distinct top-level expression where a package is used. Packages used in the fewest places are listed first.

``` r
find_deps(system.file("demopkg", package = "suggests"))
```
```
  package_used              in_file          in_expr
1        stats R/median_first_ten.R median_first_ten
2        tools R/median_first_ten.R median_first_ten
3        utils R/median_first_ten.R median_first_ten
```
