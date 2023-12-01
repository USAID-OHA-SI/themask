# align MiLB table for mapping to MSD

# DEPENDENCIES ------------------------------------------------------------

library(tidyverse)
library(glue)
library(usethis)
load_all()


# IMPORT ------------------------------------------------------------------

  data("milb")

# MUNGE -------------------------------------------------------------------

  #pick 4 leagues (one for each OU) and mimic MSD geographic structure (add milb suffix)
  df_milb <- milb %>%
    filter(level == "High A"| league == "Pacific Coast League")

  #subset table for mapping and rename to start aligning with MSD
  df_milb <- df_milb %>%
    select(snu1 = league,
           cop22_psnu = city,
           mech_name = name,
           prime_partner_name = name)

  #rename add in OU/cntry and apply suffix to all for mapping/alignment
  df_milb <- df_milb %>%
    mutate(operatingunit = "Minoria",
           country = "Minoria",
           .before = 1) %>%
    mutate(snu1 = str_remove(snu1, " League"))

  #pull four cities to use for PSNUs
  set.seed(42)
  df_milb <- df_milb %>%
    group_by(snu1) %>%
    slice_sample(n = 4) %>%
    ungroup()

  #create dummy UIDs for OU, SNU1, and PSNU
  set.seed(42)
  df_uids <-
    tibble(operatingunituid = rep(msk_gen_uid(), 16),
           snu1uid = replicate(4, msk_gen_uid()) %>% rep(4) %>% sort(),
           cop22_psnuuid = replicate(16, msk_gen_uid()))

  #bind UIDs onto geography
  df_milb <- df_milb %>%
    bind_cols(df_uids) %>%
    relocate(operatingunituid, .after = operatingunit) %>%
    relocate(snu1uid, .after = snu1) %>%
    relocate(cop22_psnuuid, .after = cop22_psnu)

  #remove partner info
  minoria_geo <- df_milb %>%
    select(-c(mech_name, prime_partner_name))

# EXPORT ------------------------------------------------------------------

  #store geography table
  usethis::use_data(minoria_geo, overwrite = TRUE)

