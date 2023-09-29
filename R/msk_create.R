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

  #mask hierarchy
  df <- msk_hierarchy(df)

  #mask mechanisms

  #mask year

  #create filename for output

}
