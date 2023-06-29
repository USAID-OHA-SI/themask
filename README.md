
# themask

This repository houses the PEPFAR MSD-style training dataset to use for testing and public facing work. This is a masked, dummy dataset that should be used for testing, training, and demoing instead of using actual data. For more information on the MSD, check out the Users Guide and Data Dictionary on [PEPFAR Panorama](https://pepfar-panorama.org/) (found in the Downloads folder under MER) 

The file can download from [USAID Google Drive](https://drive.google.com/drive/folders/1TNcPH49rGKJWXPoaYebY-4_KuwQhdogR).

To use with R to access the dataset, you must have the `googledrive` package installed and we recommend reading our [Credential Management vignette](https://usaid-oha-si.github.io/glamr/articles/credential-management.html) from [glamr](https://usaid-oha-si.github.io/glamr/index.html).


```r
library(dplyr)
library(purrr)
library(googledrive)

drive_auth()

folderpath <- "~/Data"

gdrive_locaton <- as_id("1TNcPH49rGKJWXPoaYebY-4_KuwQhdogR")

drive_files <- drive_ls(gdrive_locaton)

file_id <- drive_files %>% 
  mutate(created_time = map_chr(drive_resource, "createdTime") %>%
           ymd_hms(tz = "EST")) %>% 
  filter(created_time == max(created_time)) %>% 
  pull(id)

drive_download(file_id, path = folderpath)

```

---

*Disclaimer: The findings, interpretation, and conclusions expressed herein are those of the authors and do not necessarily reflect the views of United States Agency for International Development. All errors remain our own.*