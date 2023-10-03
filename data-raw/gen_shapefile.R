## create a shape file for mapping Minoria
# T. Essam
# originally created in USAID-OHA-SI/land_of_smiles: Scripts/shapefile_creation.R

# DEPENDENCIES ------------------------------------------------------------

library(gagglr)
load_all()
library(tidyverse)
library(googledrive)
library(scales)
library(sf)
library(usethis)
library(piggyback)


# SETUP -------------------------------------------------------------------

  #download from drive and unzip
  temp_folder()
  drive_download(as_id("11ctcmU4tCDD2OCY03_92uZM4o698PURM"),
                 file.path(folderpath_tmp, "Minoria_base.zip"))

  unzip(file.path(folderpath_tmp, "Minoria_base.zip"), #list = TRUE,
        junkpaths = TRUE,
        exdir = folderpath_tmp)

  # Census Shapefile
  census <- list.files(folderpath_tmp, pattern = ".shp", full.names = T)

  # Minoria MSD crosswalk to attach attribute data to shapefile
  ou_ids <- tibble::tribble(
                   ~psnuuid, ~OBJECTID,
              "icPkb3tE61B",      102L,
              "gwmjspIcLT4",      100L,
              "XwREtn25Uj1",       99L,
              "FBzC1U92lJn",      101L,
              "rI4Uq8vHclA",       10L,
              "yfQtNuF35qk",       11L,
              "pRaM01SfP5c",        9L,
              "NEI2PZqp3gc",       22L,
              "w1wxehdfFVl",       21L,
              "b1kJw6EiN2b",       59L,
              "FT7OhpWLZoA",       58L,
              "XhYbqN9Befa",        6L,
              "adzjTKQI4Me",      112L,
              "kMLAdyekuFP",      111L,
              "w8zAQgbBeHP",        8L,
              "gki1ZesqzfQ",      110L
              ) %>%
    left_join(minoria_geo %>% rename_all(~str_remove(., "_milb")), .)


  plot_minoria <- function(df, fillvar, labelvar) {
    df %>%
      ggplot() +
      geom_sf(aes(geometry = geometry, fill = {{fillvar}})) +
      si_style_map() +
      geom_sf_label(aes(label = {{labelvar}}), size = 7/.pt) +
      scale_fill_si(palette = "siei", discrete = TRUE)
}


# LOAD DATA ============================================================================

# Read in shapefile of Alaska Census tracts
sf_df <- st_read(census)


# List of FIPS codes used to filter the shapefile down to Minoria
fips_list <- c("02185000100", "02185000300", "02185000200",
               "02188000100", "02188000200", "02290000200",
               "02290000300", "02290000100", "02180000100",
               "02180000200", "02290000400", "02270000100",
               "02050000300", "02270000100", "02050000200",
               "02050000100", "02070000100")

minoria_psnu <- sf_df %>%
  filter(FIPS %in% fips_list) %>%
  select(FIPS, OBJECTID, geometry) %>%
  left_join(ou_ids)

plot_minoria(minoria_psnu, fillvar = snu1, labelvar = FIPS)

# Visualize ============================================================================

minoria_psnu %>%
  plot_minoria(., psnu, psnu)

# MANIPULATE SHAPEFILE =================================================================

minoria_snu1 <-
  minoria_psnu %>%
  st_make_valid() %>%
  group_by(snu1uid, snu1, operatingunituid, operatingunit, country) %>%
  summarise(geometry = sf::st_union(geometry), .groups = "drop")

minoria_snu1 %>%
  plot_minoria(snu1, snu1)

minoria_ou <-
  minoria_psnu %>%
  st_make_valid() %>%
  group_by(operatingunituid, operatingunit, country) %>%
  summarise(geometry = sf::st_union(geometry), .groups = "drop")

minoria_ou %>%
  plot_minoria(operatingunit, country)


# TAKE IT FOR A DRIVE -----------------------------------------------------

ggplot() +
  geom_sf(data = minoria_psnu, aes(geometry = geometry, fill = snu1), color = "white", linewidth = 0.25, alpha = 0.5) +
  geom_sf(data = minoria_ou, aes(geometry = geometry), fill = NA, color = "white", linewidth = 1) +
  geom_sf_text(data = minoria_psnu, aes(geometry = geometry, label = psnu), size = 7/.pt) +
  scale_fill_si(palette = "siei", discrete = TRUE) +
  scale_color_si(palette = "siei", discrete = TRUE) +
  si_style_map() +
  labs(title = "INTRODUCING MINORIA, THE NEWEST OU TO PEPFAR",
       subtitle = "PSNUs labeled on map",
       caption = "Source: Minoria faux shapefiles") +
  theme(panel.background = element_rect(fill = "#edf5fc", color = "white"),
        legend.position = "none")

# SAVE SHAPEFILES ============================================================================

#zip and upload as a release
  zip_shp <- function(sf_obj, type){
    # type <- sf_obj
    fldr_out <- file.path(folderpath_tmp, type)
    file_out <- file.path(fldr_out, paste0(type, ".shp"))
    zip_out <- paste0(fldr_out, ".zip")
    dir.create(fldr_out)
    st_write(sf_obj, file_out)
    zip_file <- list.files(fldr_out, full.names = TRUE)
    zip(zip_out, zip_file, extras = "-j")
  }


  zip_shp(minoria_psnu, "minoria_psnu")
  zip_shp(minoria_snu1, "minoria_snu1")
  zip_shp(minoria_ou, "minoria_operatingunit")

  # pb_new_release(tag = "shapefiles")

  list.files(folderpath_tmp, "minoria.*zip") %>%
    pb_upload(tag = "shapefiles", overwrite = TRUE, dir = folderpath_tmp)

#save to package
  minoria_shp_psnu <- minoria_psnu %>%
    select(-c(FIPS, OBJECTID))
  use_data(minoria_shp_psnu)
  minoria_shp_snu1 <- minoria_snu1
  use_data(minoria_shp_snu1)
  minoria_shp_ou <- minoria_ou
  use_data(minoria_shp_ou)
