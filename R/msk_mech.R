#' Mask mechanism information
#'
#' @param df
#'
#' @return df
#' @keywords internal

msk_mech <- function(df){

  if(!"mech_code" %in% df)
    return(df)

  #create mapping table
  # df_mech_map <- msk_mech_map(df)
  df_mech_map <- msk_mech_pull(df)

  #join masked table onto dataset by mech_code
  df_msk <- df %>%
    dplyr::left_join(df_mech_map,
                     by = dplyr::join_by(mech_code))

  #remove columns of unmasked data and then remove suffix so df can be reordered
  df_msk <- df_msk %>%
    dplyr::select(-any_of(df_mech_map %>%
                            dplyr::select(-mech_code) %>%
                            dplyr::rename_all(~stringr::str_remove(., "_milb")) %>%
                            names())) %>%
    dplyr::rename_all(~stringr::str_remove(., "_milb"))

  #reorder new df to match original ordering
  df_msk <- df_msk[, names(df)]

  #remove info from (unused) columns
  df_msk <- df_msk %>%
    dplyr::select(-dplyr::matches("prime_partner_duns"),
                  -dplyr::matches("prime_partner_uei"),
                  -dplyr::matches("award_number"))

  return(df_msk)
}

#' Create a mechanism mapping table
#'
#' @param df
#'
#' @return df
#' @keywords internal
#' @importFrom stats runif

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
                                   stringr::str_replace(mech_code, "0000", "000"),
                                   mech_code_milb),
           mech_code_milb = paste0("0", mech_code_milb),
           dplyr::across(c(mech_name_milb, prime_partner_name_milb),  ~ ifelse(mech_code %in% c("00000", "00001"), "Dedup", .)))

  return(df_milb_mechs)
}

#' Pulls from Existing Mech Mapping List on GDrive + Creates new
#'
#' @param df
#'
#' @return df
#' @keywords internal
#'
msk_mech_pull <- function(df){

  #import googlesheet with existing mechanism mapping
  gs_mech <- "18eRtWD1UqHAk3BdAS7mTrHzlNyMy6arQSnUmaTMRP0Y"
  df_milb_mechs <- suppressMessages(
    googlesheets4::read_sheet(googlesheets4::as_sheets_id(gs_mech),
                              col_types = "c")
  )

  #which mechanisms are new and need to be mapped to a masked mech?
  needed <- setdiff(unique(df$mech_code),
                    unique(df_milb_mechs$mech_code))

  #existing mapping table
  df_existing <- df_milb_mechs %>%
    dplyr::filter(!is.na(mech_code))

  #if there are no new mechanisms, exit early and return existing table
  if(any(is.na(needed)))
    return(df_existing)

  #sample mechanism from available list
  df_new <- df_milb_mechs %>%
    dplyr::filter(is.na(mech_code)) %>%
    dplyr::slice_sample(n = length(needed)) %>%
    dplyr::select(-mech_code) %>%
    dplyr::bind_cols(mech_code = needed)

  #bind existing and new together to export
  df_map <- dplyr::bind_rows(df_existing, df_new)

  #mech still available for future use
  df_still_available <- df_milb_mechs %>%
    dplyr::filter(!mech_code_milb %in% df_map$mech_code_milb)

  #write back to Gdrive
  df_upload <- dplyr::bind_rows(df_map, df_still_available)
  suppressMessages(
    googlesheets4::sheet_write(df_upload, gs_mech, sheet = "Sheet1")
  )

  cli::cli_alert_info("{nrow(df_new)} new mechanism{?s} introduced. Updated
    mechanism mapping table on Google Drive. There are now {nrow(df_map)}
    mechanisms in use with a total of {nrow(df_still_available)} still
    availabe for future use", wrap = TRUE)

  return(df_map)
}




