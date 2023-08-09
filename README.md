# suggests: Declare when Suggested Packages are Needed

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/suggests)](https://CRAN.R-project.org/package=suggests)
[![R-CMD-check](https://github.com/owenjonesuob/suggests/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/owenjonesuob/suggests/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/owenjonesuob/suggests/branch/main/graph/badge.svg)](https://app.codecov.io/gh/owenjonesuob/suggests?branch=main)
<!-- badges: end -->

By adding dependencies to the "Suggests" field of a package's DESCRIPTION file, and then declaring that they are needed within any dependent functionality, you can often significantly reduce the number of "hard" dependencies (i.e. Depends/Imports) required by your package.

{suggests} aims to make that workflow as minimal and painless as possible, primarily via the `need()` function, which provides a lightweight, simple, speedy way to prompt your users to install missing suggested packages.


## Installation

The current release is available from CRAN:

```r
install.packages("suggests")
```

Or if you'd like all the latest updates, you can install the development version: 

``` r
# From GitHub...
remotes::install_github("owenjonesuob/suggests")

# ... or from R-universe
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

You can also make sure a minimum version is available by appending `>=[version]`:

```r
need(
  "dplyr>=1.0.0",
  "tidyr"
)
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


## Alternatives

The [`*_installed()`](https://rlang.r-lib.org/reference/is_installed.html) functions from {rlang} provide similar functionality - more flexible, but less lightweight than this package.

You could avoid the need for _any_ package-checking dependencies, if you're willing to write slightly more code yourself! See the [Dependencies: In Practice](https://r-pkgs.org/dependencies-in-practice.html#sec-dependencies-in-suggests-r-code) chapter of [R Packages](https://r-pkgs.org/) (Wickham & Bryan).
