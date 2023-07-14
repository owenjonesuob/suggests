test_that("packages already present", {
  expect_equal(need("base"), character())

  # Even if input is horrendously nested/duplicated
  expect_equal(
    need("base", c("utils", "stats"), list("stats", c("tools"))),
    character()
  )
})



test_that("packages not present", {

  expect_error(
    suppressMessages(expect_message(

      need("_illegalpackagename_", ask = FALSE),

      paste(
        "To use this functionality, the following packages must be installed/updated:",
        "",
        "  _illegalpackagename_",
        "",
        sep = "\n"
      ),
      fixed = TRUE
    )),
    paste(
      "Please install/update packages to use this functionality:",
      "",
      "  install.packages(\"_illegalpackagename_\")",
      sep = "\n"
    ),
    fixed = TRUE
  )

})



test_that("custom message and install_cmd", {

  msg <- "Hi friend! You need to install _illegalpackagename_ to use this function."

  expect_error(
    suppressMessages(expect_message(

      need(
        "_illegalpackagename_",
        msg = msg,
        install_cmd = quote(install.packages("https://example.com/repo/_illegalpackagename_.tar.gz")),
        ask = FALSE
      ),

      msg,
      fixed = TRUE
    )),
    paste(
      "Please install/update packages to use this functionality:",
      "",
      "  install.packages(\"https://example.com/repo/_illegalpackagename_.tar.gz\")",
      sep = "\n"
    ),
    fixed = TRUE
  )

})



test_that("sufficient version", {

  expect_equal(need("base>=3.0.0"), character())

})



test_that("version too low, or package missing altogether", {

  expect_error(
    suppressMessages(expect_message(

      need("base>=9.9.9", ask = FALSE),

      paste(
        "To use this functionality, the following packages must be installed/updated:",
        "",
        "  base>=9.9.9",
        "",
        sep = "\n"
      ),
      fixed = TRUE
    )),
    paste(
      "Please install/update packages to use this functionality:",
      "",
      "  install.packages(\"base\")",
      sep = "\n"
    ),
    fixed = TRUE
  )


  expect_error(
    suppressMessages(expect_message(

      need("_illegalpackagename_ >= 9.9.9", ask = FALSE),

      paste(
        "To use this functionality, the following packages must be installed/updated:",
        "",
        "  _illegalpackagename_ >= 9.9.9",
        "",
        sep = "\n"
      ),
      fixed = TRUE
    )),
    paste(
      "Please install/update packages to use this functionality:",
      "",
      "  install.packages(\"_illegalpackagename_\")",
      sep = "\n"
    ),
    fixed = TRUE
  )

})
