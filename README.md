## themask <img src="man/figures/logo.png" align="right" height="120" alt="" />
<!-- badges: start -->
[![R-CMD-check](https://github.com/USAID-OHA-SI/themask/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/USAID-OHA-SI/themask/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->


Masks and houses the PEPFAR MSD-style training dataset for testing/training

## Overview

This repository houses the PEPFAR MSD-style training dataset to use for testing and public facing work. This is a masked, dummy dataset that should be used for testing, training, and demoing instead of using actual data. For more information on the MSD, check out the Users Guide and Data Dictionary on [PEPFAR Panorama](https://pepfar-panorama.org/) (found in the Downloads folder under MER) 

The file can download from [USAID Google Drive](https://drive.google.com/drive/folders/1TNcPH49rGKJWXPoaYebY-4_KuwQhdogR).

To use with R to access the dataset, you must have the `googledrive` package installed and we recommend reading our [Credential Management vignette](https://usaid-oha-si.github.io/glamr/articles/credential-management.html) from [glamr](https://usaid-oha-si.github.io/glamr/index.html).

## Installation

`themask` is not on CRAN, so you will have to install it directly from GitHub using `remotes`.

If you do not have `remotes` installed, you will have to run the `install.packages("remotes")` line in the code below as well.


``` r
## SETUP

  #install package with vignettes
    install.packages("remotes")
    remotes::install_github("USAID-OHA-SI/themask", build_vignettes = TRUE)
    
  #load the package
    library(themask)

## LIST TYPES OF STYLES INCLUDED WITH PACKAGE
  ls(package:themask)
```

---

*Disclaimer: The findings, interpretation, and conclusions expressed herein are those of the authors and do not necessarily reflect the views of United States Agency for International Development. All errors remain our own.*
