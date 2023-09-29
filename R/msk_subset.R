
#' Subset PSD
#'
#' Filter PSD down to sixteen PSNUs and to the relevant indicators/areas.
#'
#' @param df
#'
#' @return df
#' @export
#'
msk_subset <- function(df){

  #filter to select geography (determined in `data-raw/sel_geo.R`)
  df_lim <- df %>%
    dplyr::filter(psnuuid %in% msk_psnuuid)

  #filter indicator
  #confirm MSD
  type <- gophr::identify_psd(df)

  if(type %in% c("MSD (PSNU_IM)", "MSD (NAT_SUBNAT)")){
    df_lim <- df_lim %>%
      dplyr::filter(indicator %in% c(gophr::cascade_ind,
                                     "POP_EST", "PLHIV", "TX_CURR_SUBNAT"))
  }

  return(df_lim)
}
