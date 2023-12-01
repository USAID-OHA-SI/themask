#' Mask Hierarchy
#'
#' @param df
#'
#' @return df
#' @keywords internal

msk_hierarchy <- function(df){

  #create a mapping table between PEPFAR PSNUs and masked table (add suffix)
  msk_geo <- dplyr::bind_cols(cop22_psnuuid = msk_psnuuid,
                              minoria_geo %>% dplyr::rename_with(~paste0(., "_milb")))

  #join masked table onto dataset by cop22_psnuuid
  df_msk <- dplyr::left_join(df, msk_geo, by = dplyr::join_by(cop22_psnuuid))

  #align psnu (introduced FY23Q4)
  df_msk <- df_msk %>%
    dplyr::mutate(psnu = ifelse(cop22_psnu == psnu, cop22_psnu_milb, snu1_milb),
                  psnuuid = ifelse(cop22_psnuuid == psnuuid, cop22_psnuuid_milb, snu1uid_milb))

  #remove columns of unmasked data and then remove suffix so df can be reordered
  df_msk <- df_msk %>%
    dplyr::select(-dplyr::any_of(names(minoria_geo))) %>%
    dplyr::rename_all(~stringr::str_remove(., "_milb"))

  #reorder new df to match original ordering
  df_msk <- df_msk[, names(df)]

  return(df_msk)
}
