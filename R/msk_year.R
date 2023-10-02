#' Mask Fiscal Year
#'
#' @param n_years number of years to add to `fiscal_year`, default = 37
#'
#' @return df
#' @keywords internal

msk_year <- function(df, n_years = 37){
  dplyr::mutate(df, fiscal_year = fiscal_year + n_years)
}
