#' Import PSD to mask
#'
#' @param filepath path to a PSD file, either a PSNUxIM or NAT_SUBNAT
#' @param call
#'
#' @return df
#' @keywords internal
#'

msk_import <- function(filepath, call = caller_env()){

  #import PSD
  df <- gophr::read_psd(filepath)

  #confirm MSD
  type <- gophr::identify_psd(df)

  if(type %in% c("MSD (PSNU_IM)", "MSD (NAT_SUBNAT)"))
    cli::cli_abort("{.arg filepath} must refer to a PSNUxIM MSD or NAT_SUBNAT MSD",
                   call = call)
  return(df)
}
