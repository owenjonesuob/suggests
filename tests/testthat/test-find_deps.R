test_that("deps specified in various ways", {

  expect_equal(
    find_deps(system.file("demopkg", package = "suggests")),
    data.frame(
      package_used = c("stats", "tools", "utils"),
      in_file = "R/median_first_ten.R",
      in_expr = "median_first_ten"
    )
  )


  expect_equal(
    find_deps(system.file("demopkg", package = "suggests"), threshold = 0),
    data.frame(
      package_used = character(),
      in_file = character(),
      in_expr = character()
    )
  )

})
