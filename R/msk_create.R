#' Create the Masked Dataset
#'
#' @param filepath path to the PSD file (PSNUxIM or NAT_SUBNAT)
#'
#' @return dataframe with converted geography + mech info
#' @export

msk_create <- function(filepath){

  #import PSD
  df <- msk_import(filepath)

  #limit dataset to select PSNUs
  df <- msk_subset(df)


}
