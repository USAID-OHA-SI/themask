## develop list of countries + PSNUs to use

# DEPENDENCIES ------------------------------------------------------------

library(tidyverse)
library(gagglr)
library(usethis)

# IMPORT -----------------------------------------------------------------

  #PSNUxIM MSD
  #created with FY23Q3c MSD
  df <- si_path() %>%
    return_latest("PSNU_IM") %>%
    read_psd()

# LIMIT GEOGRAPHY ---------------------------------------------------------

  get_metadata()

  #pull the four similarly sized, operating units based on their TX_CURR
  v_ouuid <- df %>%
    filter(fiscal_year == metadata$curr_fy,
           indicator == "TX_CURR") %>%
    pluck_totals() %>%
    count(operatingunit, operatingunituid, wt = targets, sort = TRUE)  %>%
    slice(6:9) %>%
    pull(operatingunituid)

  #select 4 similarly sized PSNUs from those OUs based on their TX_CURR
  df_geo <- df %>%
    filter(fiscal_year == metadata$curr_fy,
           str_detect(psnu, "_Military", negate = TRUE),
           operatingunituid %in% v_ouuid,
           indicator == "TX_CURR") %>%
    pluck_totals() %>%
    count(operatingunit, operatingunituid, country, snu1, snu1uid, cop22_psnu, cop22_psnuuid, psnu, psnuuid, wt = targets, sort = TRUE) %>%
    arrange(operatingunit, n) %>%
    group_by(operatingunit) %>%
    slice(6:9) %>%
    ungroup() %>%
    select(-n)

# EXPORT ------------------------------------------------------------------

  #export/store for subsetting PEPFAR dataset
  msk_psnuuid <- pull(df_geo, cop22_psnuuid)

  #export OU list to compare new run against what is historically in there
  msk_ouuids <- unique(df_geo$operatingunituid)

  #store internal datasets for testing
  use_data(msk_psnuuid, msk_ouuids,
           internal = TRUE, overwrite = TRUE)
