# PROJECT:  themask
# AUTHOR:   A.Chafetz | USAID
# PURPOSE:  scrap masked names for use in dataset
# REF ID:   350ad6d7 
# LICENSE:  MIT
# DATE:     2023-06-20
# UPDATED: 

# DEPENDENCIES ------------------------------------------------------------
  
  library(tidyverse)
  library(glue)
  library(rvest)
  library(janitor)

# GLOBAL VARIABLES --------------------------------------------------------
  

url_wiki <- 'https://en.wikipedia.org/wiki/Minor_League_Baseball'

table_loc <- '//*[@id="mw-content-text"]/div[1]/table'

table_names <- "[4]"
table_leagues <- "[3]"

# IMPORT ------------------------------------------------------------------
  
  #scrape table of MiLB names
  wikitable <- url_wiki %>%
    read_html() %>%
    html_nodes(xpath=glue(table_loc, table_names)) %>% 
    html_table(fill = TRUE)

  #scrape leagues table of MiLB names
  wikitable_lg <- url_wiki %>%
    read_html() %>%
    html_nodes(xpath=glue(table_loc, table_leagues)) %>% 
    html_table(fill = TRUE)

# MUNGE -------------------------------------------------------------------

  #convert html to a data frame
  df_milb <- wikitable %>% 
    pluck(data.frame) %>% 
    as_tibble() %>% 
    clean_names()
  
  df_milb_lg <- wikitable_lg %>% 
    pluck(data.frame) %>% 
    as_tibble() %>% 
    clean_names()
  
  #remove mlb league
  df_milb <- df_milb %>% 
    filter(str_detect(division, "League", negate = TRUE))

  #pivot long
  df_milb <- df_milb %>% 
    pivot_longer(cols = ends_with("_a"),
                 names_to = "level",
                 values_to = "team")

  #extract league initials    
  df_milb <- df_milb %>% 
    # separate_wider_regex(team, c(team = ".*", league = "[:upper:]{2df_milb_lg,3}$"))
    mutate(map = str_extract(team, "[:upper:]{2,3}$"), .before = team) %>% 
    mutate(team = str_remove(team, "[:upper:]{2,3}$")) 

  #mapping of milb league initials to league name
  df_milb_lg <- df_milb_lg %>% 
    rename_with(~paste0(., ".map")) %>% 
    rename_with(~str_replace(., "_1.map", ".league")) %>% 
    pivot_longer(everything(),
                 names_to = c(NA, ".value"),
                 names_pattern = "(.*).(league|map)") %>%
    filter(league != "—")

  #map league name onto table
  df_milb <- df_milb %>% 
    left_join(df_milb_lg) %>%
    select(-map)
  
  #update level
  df_milb <- df_milb %>% 
    mutate(level = case_match(
      level,
      "triple_a" ~ "AAA",
      "double_a" ~ "AA",
      "single_a" ~ "A",
      "high_a" ~ "High A"))
  
  #review 3 word teams (two name location or team name?)
  df_milb <- df_milb %>% 
    # select(team) %>% 
    mutate(word_count = str_count(team, '\\w+')) %>% 
    mutate(city = case_when(str_count(team, '\\w+') > 2 ~ word(team, 1, 2),
                            str_count(team, '\\w+') == 2 ~ word(team, 1, 1)),
           name = case_when(str_count(team, '\\w+') == 4 ~ word(team, 3,4),
                            str_count(team, '\\w+') == 3 ~ word(team, 3),
                            str_count(team, '\\w+') == 2 ~ word(team, 2)),
           review = word_count == 3) %>% +
    arrange(desc(word_count), team) %>% 
    relocate(team, .before = city)
  
  #export for manual review/editing of team names
  write_csv(df_milb, "Data_public/milb_out.csv")
  
  #impot edited version (_manual)
  df_milb <- read_csv("Data_public/milb_out_manual.csv")
  
  #subset table for mapping and rename
  map_tbl <- df_milb %>% 
    select(snu1 = league,
           psnu = city,
           mech_name = name,
           prime_partner_name = name)
  
  #rename as mapping table
  map_tbl <- map_tbl %>% 
    mutate(operatingunit = "Minoria",
           country = "Minoria",
           .before = 1) %>% 
    mutate(snu1 = str_remove(snu1, " League"),
           mech_code = row_number() + 1000) %>% 
    rename_all(~glue("{.}_milb"))
  
  #store mapping table
  write_csv(map_tbl, "Data_public/map_tbl.csv")

  
                   
            