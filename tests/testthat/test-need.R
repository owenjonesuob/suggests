test_that("packages already present", {
  expect_equal(need("base"), character())

  # Even if input is horrendously nested/duplicated
  expect_equal(
    need("base", c("utils", "stats"), list("stats", c("tools"))),
    character()
  )
})



test_that("packages not present", {

  expect_message(
    expect_error(
      need("_illegalpackagename_", ask = FALSE),
      paste(
        "Please install the following packages to use this functionality: ",
        "",
        "  install.packages(c(\"_illegalpackagename_\"))",
        sep = "\n"
      ),
      fixed = TRUE
    ),
    "Additional packages are required to use this functionality: _illegalpackagename_\n\n",
    fixed = TRUE
  )

})
