test_that("load equals true (default)", {

  expect_true(check_installed("utils"))

  expect_equal(
    check_installed(c("utils", "testthat", "thispackagedoesnotexist")),
    c("utils" = TRUE, "testthat" = TRUE, "thispackagedoesnotexist" = FALSE)
  )

  # nonsense library - {testthat} is already loaded, so we get TRUE regardless
  expect_true(check_installed("testthat", lib.loc = "thislibdoesnotexist"))


})


test_that("load equals false", {

  expect_true(check_installed("utils", load = FALSE))

  expect_equal(
    check_installed(c("utils", "testthat", "thispackagedoesnotexist"), load = FALSE),
    c("utils" = TRUE, "testthat" = TRUE, "thispackagedoesnotexist" = FALSE)
  )


  # nonsense library - no {testthat} in there!
  expect_false(check_installed("testthat", lib.loc = "thislibdoesnotexist", load = FALSE))

})
