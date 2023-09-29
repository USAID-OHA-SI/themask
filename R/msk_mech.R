#' Mask mechanism information
#'
#' @param df
#'
#' @return df
#' @keywords internal

msk_mech <- function(df){

  #create mapping table
  df_mech_map <- msk_mech_map(df)

  #join masked table onto dataset by mech_code
  df_msk <- df_msk %>%
    dplyr::left_join(df_mech_map,
                     by = join_by(mech_code))

  #remove columns of unmasked data and then remove suffix so df can be reordered
  df_msk <- df_msk %>%
    dplyr::select(-any_of(df_mech_map %>%
                            dplyr::select(-mech_code) %>%
                            dplyr::rename_all(~stringr::str_remove(., "_milb")) %>%
                            names())) %>%
    dplyr::rename_all(~str_remove(., "_milb"))

  #reorder new df to match original ordering
  df_msk <- df_msk[, names(df)]

  #remove info from (unused) columns
  df_msk <- df_msk %>%
    dplyr::select(-dplyr::matches("prime_partner_duns"),
                  -dplyr::matches("prime_partner_uei"),
                  -dplyr::match("award_number"))

  return(df_msk)
}

#' Create a mechanism mapping table
#'
#' @param df
#'
#' @return df
#' @keywords internal

msk_mech_map <- function(df){
  #create a new table of mech information to map onto dataset
  set.seed(42)
  df_milb_mechs <- tibble::tibble(mech_code = unique(df$mech_code),
                          mech_code_milb = runif(length(unique(df$mech_code)), 1200, 1800) %>% round %>% as.character,
                          mech_name_milb = sample(milb$name, length(unique(df$mech_code))),
                          prime_partner_name_milb = mech_name_milb)

  #keep dedups
  df_milb_mechs <- df_milb_mechs %>%
    dplyr::mutate(mech_code_milb = ifelse(mech_code %in% c("00000", "00001"),
                                   str_replace(mech_code, "0000", "000"),
                                   mech_code_milb),
           mech_code_milb = paste0("0", mech_code_milb),
           dplyr::across(c(mech_name_milb, prime_partner_name_milb),  ~ ifelse(mech_code %in% c("00000", "00001"), "Dedup", .)))

  return(df_msk)
}
