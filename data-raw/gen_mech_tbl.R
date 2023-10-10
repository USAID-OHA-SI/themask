## code to prepare `gen_mech_tbl` dataset goes here
library(tidyverse)
load_all(.)

set.seed(42)
df_milb_mechs <- milb %>%
  dplyr::select(mech_name = name) %>%
  dplyr::mutate(prime_partner_name = mech_name,
                mech_code =  nrow(milb) %>%
                  runif(1200, 1800) %>%
                  round %>%
                  as.character %>%
                  stringr::str_pad(5, side = "left", "0")) %>%
  dplyr::relocate(mech_code, .before = everything())

df_dedups <- tibble::tibble(mech_code = c("00000", "00001"),
                                mech_name = rep("Dedup", 2),
                                prime_partner_name = rep("Dedup", 2))

minoria_mechs <- dplyr::bind_rows(df_milb_mechs, df_dedups)

usethis::use_data(minoria_mechs, overwrite = TRUE)


# POST TO GDRIVE ----------------------------------------------------------


gs_fldr <-  googledrive::as_id("1v3Hzpn6vjqmdnlkEGtzJADnIWiTNp1Q4")

# googledrive::drive_create("minoria_mechs",
#                           path = gs_fldr,
#                           type = "spreadsheet")

gs_id <- googledrive::drive_ls(gs_fldr)$id

googlesheets4::sheet_names(gs_id)

minoria_mechs %>%
  dplyr::rename_with(~paste0(., "_milb")) %>%
  dplyr::mutate(mech_code = ifelse(mech_name_milb == "Dedup", mech_code_milb, NA_character_)) %>%
  googlesheets4::sheet_write(gs_id, sheet = "Sheet1")

