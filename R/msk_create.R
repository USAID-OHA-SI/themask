#' Create the Masked Dataset
#'
#' @param filepath path to the MSD file
#'
#' @return dataframe with converted geography + mech info
#' @export

msk_create <- function(filepath){
  df <- gophr::read_psd(filepath)
}
