#' Create the Masked Dataset
#'
#' @param filepath path to the PSD file (PSNUxIM or NAT_SUBNAT)
#' @param output_folder location where you want to store the new file
#'
#' @return dataframe with converted geography + mech info
#' @export

msk_create <- function(filepath, output_folder){

  #import PSD
  df <- msk_import(filepath)

  #limit dataset to select PSNUs
  df <- msk_subset(df)

  #mask hierarchy
  df <- msk_hierarchy(df)

  #mask mechanisms
  df <- msk_mech(df)

  #morph year
  df <- msk_year(df)

  #export
  msk_export(df, filepath, output_folder)

}
