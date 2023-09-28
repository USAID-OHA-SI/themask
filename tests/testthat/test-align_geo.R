test_that("masked geography (Minoria) retains its structure", {
  col_names <- c("operatingunit_milb", "operatingunituid_milb",
                 "country_milb", "snu1_milb", "snu1uid_milb",
                 "psnu_milb", "psnuuid_milb")

  expect_equal(names(minoria_geo), col_names)
  expect_equal(nrow(minoria_geo), 16)
})
