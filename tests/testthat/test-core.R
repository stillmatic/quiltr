context("test-core")

test_that("ls returns something", {
    ret <- qls()
    expect_less_than(2, length(ret))
})
