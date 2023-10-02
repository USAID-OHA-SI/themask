#' Mask Hierarchy
#'
#' @param df
#'
#' @return df
#' @keywords internal

msk_hierarchy <- function(df){

  #create a mapping table between PEPFAR PSNUs and masked table
  msk_geo <- dplyr::bind_cols(psnuuid = msk_psnuuid, minoria_geo)

  #join masked table onto dataset by psnuuid
  df_msk <- dplyr::left_join(df, msk_geo, by = dplyr::join_by(psnuuid))

  #remove columns of unmasked data and then remove suffix so df can be reordered
  df_msk <- df_msk %>%
    dplyr::select(-dplyr::any_of(minoria_geo %>%
                     dplyr::rename_all(~stringr::str_remove(., "_milb")) %>%
                     names())) %>%
    dplyr::rename_all(~stringr::str_remove(., "_milb"))

  #reorder new df to match original ordering
  df_msk <- df_msk[, names(df)]

  return(df_msk)
}
