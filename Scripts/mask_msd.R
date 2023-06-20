# PROJECT:  themask
# AUTHOR:   A.Chafetz | USAID
# PURPOSE:  masked datast
# REF ID:   20dd0da7 
# LICENSE:  MIT
# DATE:     2023-06-16
# UPDATED: 

# DEPENDENCIES ------------------------------------------------------------
  
  library(tidyverse)
  library(gagglr)
  library(glue)
  library(scales)
  library(extrafont)
  library(tidytext)
  library(patchwork)
  library(ggtext)
  

# GLOBAL VARIABLES --------------------------------------------------------
  
  # ref_id <- "20dd0da7" #id for adorning to plots, making it easier to find on GH
  
  get_metadata() #list of MSD metadata elements

# IMPORT ------------------------------------------------------------------
  
  df <- si_path() %>% 
    return_latest("PSNU_IM") %>% 
    read_psd()   
  

# MUNGE -------------------------------------------------------------------
  
  
  df <- df %>% 
    filter(operatingunituid == )
  
  psnus <- df %>% 
    filter(fiscal_year == metadata$curr_fy,
           indicator == "TX_CURR") %>% 
    pluck_totals() %>% 
    count(psnu, wt = targets, sort = TRUE) %>% 
    slice_head(n = 9) %>% 
    pull(psnu)

  df <- df %>% 
    filter(psnu %in% psnus)

  glimpse(df)  
  
  partners <- unique(df$mech_code)
  
  set.seed(42)
  
  tibble(psnuuid = unique(df$psnuuid))
    

  
runif(9)

  map_tbl %>%
    group_by(snu1_milb) %>% 
    slice_sample(n = 3) %>% 
    ungroup() %>%
    slice_head(n = length(psnus))
    bind_rows(unique(df$psnuuid))
    bind_cols(order = runif(nrow(map_tbl)))
    mutate(order =map(prime_partner_name_milb, ~runif))
slice_sample()
  