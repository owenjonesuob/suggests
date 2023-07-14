test_that("load equals true", {

  expect_true(is_installed("utils", load = TRUE))

  expect_equal(
    is_installed(c("utils", "testthat", "thispackagedoesnotexist"), load = TRUE),
    c("utils" = TRUE, "testthat" = TRUE, "thispackagedoesnotexist" = FALSE)
  )

})


test_that("load equals false (default)", {

  expect_true(is_installed("utils"))

  expect_equal(
    is_installed(c("utils", "testthat", "thispackagedoesnotexist")),
    c("utils" = TRUE, "testthat" = TRUE, "thispackagedoesnotexist" = FALSE)
  )


  # nonsense library - no {testthat} in there!
  expect_false(is_installed("testthat", lib.loc = "thislibdoesnotexist"))

})
