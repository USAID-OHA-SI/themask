
#' Subset PSD
#'
#' Filter PSD down to sixteen PSNUs and to the relevant indicators/areas.
#'
#' @param df
#'
#' @return df
#' @keywords internal
#'
msk_subset <- function(df){

  #filter to select geography (determined in `data-raw/sel_geo.R`)
  df_lim <- df %>%
    dplyr::filter(cop22_psnuuid %in% msk_psnuuid)

  #filter indicator
  #confirm MSD
  type <- gophr::identify_psd(df)

  if(type %in% c("MSD (PSNU_IM)", "MSD (NAT_SUBNAT)")){
    df_lim <- df_lim %>%
      dplyr::filter(indicator %in% c(gophr::cascade_ind,
                                     "POP_EST", "PLHIV", "TX_CURR_SUBNAT"))
  }

  if(type == "MSD (PSNU_IM)" && nrow(df_lim) == 0){
    cli::cli_abort("The dataframe must contain the cascade indicator.
                   The filter results in zero rows of data")
  }

  if(type == "MSD (NAT_SUBNAT)" && nrow(df_lim) == 0){
    cli::cli_abort("The dataframe must contain the key indicators - POP_EST, PLHIV, TX_CURR_SUBNAT.
                   The filter results in zero rows of data")
  }

  return(df_lim)
}
