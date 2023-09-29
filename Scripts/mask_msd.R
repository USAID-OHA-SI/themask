# PROJECT:  themask
# AUTHOR:   A.Chafetz | USAID
# PURPOSE:  masked dataset for training
# REF ID:   20dd0da7
# LICENSE:  MIT
# DATE:     2023-06-16
# UPDATED:  2023-07-18

# DEPENDENCIES ------------------------------------------------------------

  library(tidyverse)
  library(gagglr)
  library(glue)
  library(googledrive)

# GLOBAL VARIABLES --------------------------------------------------------

  get_metadata() #list of MSD metadata elements

  path_gdrive <- as_id("1TNcPH49rGKJWXPoaYebY-4_KuwQhdogR")

# FUNCTION - GENERATE UID -------------------------------------------------

  #from: ICPI/TrainingDataset/R/generateUID.R
  generateUID <- function(codeSize=11){
    #Generate a random seed
    runif(1)
    allowedLetters<-c(LETTERS,letters)
    allowedChars<-c(LETTERS,letters,0:9)
    #First character must be a letter according to the DHIS2 spec
    firstChar<-sample(allowedLetters,1)
    otherChars<-sample(allowedChars,codeSize-1)
    uid<-paste(c(firstChar,paste(otherChars,sep="",collapse="")),sep="",collapse="")
    return(uid)
  }

# IMPORT ------------------------------------------------------------------

  #PSNUxIM MSD
  df <- si_path() %>%
    return_latest("PSNU_IM") %>%
    read_psd()

  #NAT_SUBNAT MSD
  df_subnat <- si_path() %>%
    return_latest("NAT_SUBNAT") %>%
    read_psd()

  #mapping table for MiLB names/geographies (munge_mask_names.R)
  df_milb <- read_csv("Data_public/milb_out_manual.csv")

# LIMIT GEOGRAPHY ---------------------------------------------------------

  #pull the four similarly sized, operating units based on their TX_CURR
  v_cntry <- df %>%
    filter(fiscal_year == metadata$curr_fy,
           indicator == "TX_CURR") %>%
    pluck_totals() %>%
    count(country, wt = targets, sort = TRUE)  %>%
    slice(6:9) %>%
    pull(country)

  #select 4 similarly sized PSNUs from those OUs based on their TX_CURR
  df_geo <- df %>%
    filter(fiscal_year == metadata$curr_fy,
           str_detect(psnu, "_Military", negate = TRUE),
           country %in% v_cntry,
           indicator == "TX_CURR") %>%
    pluck_totals() %>%
    count(operatingunit, operatingunituid, country, snu1, snu1uid, psnu, psnuuid, wt = targets, sort = TRUE) %>%
    arrange(country, n) %>%
    group_by(country) %>%
    slice(6:9) %>%
    ungroup() %>%
    select(-n)

  #limit dataset to those PSNUs and only for clinical cascade indicators
  df_lim <- df %>%
    filter(psnuuid %in% df_geo$psnuuid,
           indicator %in% cascade_ind)


# ALIGN MILB FOR GEOGRAPHY MAPPING ----------------------------------------

  #pick 4 leagues (one for each OU) and mimic MSD geographic structure (add milb suffix)
  df_milb_geo <- df_milb %>%
    filter(level == "High A"| league == "Pacific Coast League") %>%
    mutate(league = str_remove(league, " League")) %>%
    select(snu1 = league,
           psnu = city) %>%
    mutate(operatingunit = "Minoria",
           country = "Minoria",
           .before = 1) %>%
    rename_all(~glue("{.}_milb"))

  #pull four cities to use for PSNUs
  set.seed(42)
  df_milb_geo <- df_milb_geo %>%
    group_by(snu1_milb) %>%
    slice_sample(n = 4) %>%
    ungroup()

  #create UIDs for OU, SNU1, and PSNU
  set.seed(42)
  df_uids <-
    tibble(operatingunituid_milb = rep(generate_uid(), 16),
         snu1uid_milb = replicate(4, generate_uid()) %>% rep(4) %>% sort(),
         psnuuid_milb = replicate(16, generate_uid()))

  #bind UIDs onto geography
  df_milb_geo <- bind_cols(df_milb_geo, df_uids)

  #create a mapping table between PEPFAR PSNUs and masked table
  df_geo_map <- bind_cols(df_geo, df_milb_geo)

  #export mapping table for reference
  write_csv(df_geo_map, "Dataout/geo_map.csv", na = "")


# MASK GEOGRAPHY ----------------------------------------------------------

  #join masked table onto dataset by psnuuid
  df_lim_masked <- df_lim %>%
    left_join(df_geo_map %>%
                select(psnuuid, ends_with("milb")),
              by = join_by(psnuuid))

  #remove columns of unmasked data and then remove suffix so df can be reordered
  df_lim_masked <- df_lim_masked %>%
    select(-any_of(df_milb_geo %>%
                    rename_all(~str_remove(., "_milb")) %>%
                    names())) %>%
    rename_all(~str_remove(., "_milb"))

  #reorder new df to match original ordering
  df_lim_masked <- df_lim_masked[, names(df_lim)]


# ALIGN MILB FOR MECHANISM MAPPING ----------------------------------------

  #create a new table of mech information to map onto dataset
  set.seed(42)
  df_milb_mechs <- tibble(mech_code = unique(df_lim_masked$mech_code),
         mech_code_milb = runif(length(unique(df_lim_masked$mech_code)), 1200, 1800) %>% round %>% as.character,
         mech_name_milb = sample(df_milb$name, length(unique(df_lim_masked$mech_code))),
         prime_partner_name_milb = mecprime_partner_name_milbh_name_milb)

  #keep dedups
  df_milb_mechs <- df_milb_mechs %>%
    mutate(mech_code_milb = ifelse(mech_code %in% c("00000", "00001"),
                                  str_replace(mech_code, "0000", "000"),
                                  mech_code_milb),
           mech_code_milb = paste0("0", mech_code_milb),
           across(c(mech_name_milb, ),  ~ ifelse(mech_code %in% c("00000", "00001"), "Dedup", .)))

  #export mapping table for reference
  write_csv(df_milb_mechs, "Dataout/mech_map.csv", na = "")


# MASK MECHANISMS ---------------------------------------------------------

  #join masked table onto dataset by mech_code
  df_lim_masked <- df_lim_masked %>%
    left_join(df_milb_mechs,
              by = join_by(mech_code))

  #remove columns of unmasked data and then remove suffix so df can be reordered
  df_lim_masked <- df_lim_masked %>%
    select(-any_of(df_milb_mechs %>%
                     select(-mech_code) %>%
                     rename_all(~str_remove(., "_milb")) %>%
                     names())) %>%
    rename_all(~str_remove(., "_milb"))

  #reorder new df to match original ordering
  df_lim_masked <- df_lim_masked[, names(df_lim)]

  #remove info from (unused) columns
  df_lim_masked <- df_lim_masked %>%
    select(-c(prime_partner_duns, prime_partner_uei, award_number))

# MASK YEAR ---------------------------------------------------------------

  df_lim_masked <- df_lim_masked %>%
    mutate(fiscal_year = fiscal_year + 37)


# MASK NAT_SUBNAT ---------------------------------------------------------

  #subnset dataset to just geography and indicators of interest
  df_subnat_lim <- df_subnat %>%
    filter(psnuuid %in% df_geo$psnuuid,
           indicator %in% c("POP_EST", "PLHIV", "TX_CURR_SUBNAT"),
           !is.na(targets))

  #join masked table onto dataset by psnuuid
  df_subnat_lim_masked <- df_subnat_lim %>%
    left_join(df_geo_map %>%
                select(psnuuid, ends_with("milb")),
              by = join_by(psnuuid))

  #remove columns of unmasked data and then remove suffix so df can be reordered
  df_subnat_lim_masked <- df_subnat_lim_masked %>%
    select(-any_of(df_milb_geo %>%
                     rename_all(~str_remove(., "_milb")) %>%
                     names())) %>%
    rename_all(~str_remove(., "_milb"))

  #reorder new df to match original ordering
  df_subnat_lim_masked <- df_subnat_lim_masked[, names(df_subnat_lim)]

  #mask year
  df_subnat_lim_masked <- df_subnat_lim_masked %>%
    mutate(fiscal_year = fiscal_year + 37)

# EXPORT ------------------------------------------------------------------

  #masked year for
  v_yr <- df_lim_masked %>%
    distinct(fiscal_year) %>%
    filter(fiscal_year == min(fiscal_year) | fiscal_year == max(fiscal_year)) %>%
    mutate(fiscal_year = str_remove(fiscal_year, "20")) %>%
    pull() %>%
    paste0(collapse = "-") %>%
    paste0("FY", .)

  #export
  output_filename <- si_path() %>%
    return_latest("PSNU_IM") %>%
    basename() %>%
    str_replace("MER_Structured_Dataset", "MER_Structured_TRAINING_Dataset") %>%
    str_replace("FY.*(?=_20)", v_yr) %>%
    str_replace("zip", "txt")

  output_filepath <- file.path("Dataout", output_filename)
  output_filepath_zip <- str_replace(output_filepath, "txt", "zip")

  write_tsv(df_lim_masked, output_filepath)

  zip(output_filepath_zip, output_filepath)

  #remove csv (keeping zipped file)
  unlink(output_filepath)

  #push to Gdrive
  drive_upload(output_filepath_zip,
               path_gdrive,
               name = basename(output_filepath),
               overwrite = TRUE)

  #repeat export for SUBNAT
  #export
  output_subnat_filepath <- str_replace(output_filepath, "PSNU_IM", "NAT_SUBNAT")
  output_subnat_filepath_zip <- str_replace(output_filepath_zip, "PSNU_IM", "NAT_SUBNAT")

  write_tsv(df_subnat_lim_masked, output_subnat_filepath)

  zip(output_subnat_filepath_zip, output_subnat_filepath)

  #remove csv (keeping zipped file)
  unlink(output_subnat_filepath)

  #push to Gdrive
  drive_upload(output_subnat_filepath_zip,
               path_gdrive,
               name = basename(output_subnat_filepath),
               overwrite = TRUE)


  #Upload mapping files
  "Dataout/geo_map.csv" %>%
    drive_upload(.,
                 path_gdrive,
                 name = basename(.),
                 type = "spreadsheet",
                 overwrite = TRUE)


  "Dataout/mech_map.csv" %>%
    drive_upload(.,
                 path_gdrive,
                 name = basename(.),
                 type = "spreadsheet",
                 overwrite = TRUE)
