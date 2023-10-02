test_that("there are 16 stored psnus", {
  expect_equal(length(msk_psnuuid), 16)
})

test_that("the countries have not changed", {
  expect_snapshot(msk_ouuids)
})


test_that("the PSNUs have not changed", {
  expect_snapshot(msk_psnuuid)
})
