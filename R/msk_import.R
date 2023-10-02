#' Import PSD to mask
#'
#' @param filepath path to a PSD file, either a PSNUxIM or NAT_SUBNAT
#' @param call
#'
#' @return df
#' @keywords internal
#'

msk_import <- function(filepath){

  #fill with default path to PSNUxIM if not provided
  if(missing(filepath))
    filepath <- glamr::si_path() %>% glamr::return_latest("PSNU_IM")

  #import PSD
  df <- gophr::read_psd(filepath)

  #confirm MSD
  type <- gophr::identify_psd(df)

  if(!type %in% c("MSD (PSNU_IM)", "MSD (NAT_SUBNAT)"))
    cli::cli_abort("{.arg filepath} must refer to a PSNUxIM MSD or NAT_SUBNAT MSD")

  return(df)
}
