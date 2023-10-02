#' Create the Masked Dataset
#'
#' This function is used to create a masked dataset for use in testing and
#' training. The data are subset to 16 PSNUs and masked across geographic and
#' mechanism variables. Either the PSNUxIM or NAT_SUBNAT Structured Datasets
#' can be masked.
#'
#' @param filepath path to the PSD file (PSNUxIM or NAT_SUBNAT)
#' @param output_folder location where you want to store the new file (default =
#'   does not export the data)
#'
#' @return dataframe with converted geography + mech info
#' @export
#' @examples \dontrun{
#' #create a masked dataset
#' library(glamr)
#' library(themask)
#'
#' #store path to latest MSD
#' path <- si_path() %>% return_latest("PSNU_IM")
#'
#' #create a masked dataset from the PSNUxIM MSD
#' msk_create(path, "project1/data")
#' }

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
