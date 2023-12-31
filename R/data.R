#' MiLB Information Table
#'
#' @description
#' This table has been extracted from Wikipedia's Minor League Baseball (MiLB)
#' page and is used for masking geographic and partner information in PEPFAR's
#' MER Structured Datasets (MSD).
#'
#' @format ## `milb`
#' A data frame with 120 rows and 6 columns:
#' \describe{
#'   \item{division}{MLB Division (East, Central, West)}
#'   \item{mlb_team}{Affiliated MLB}
#'   \item{level}{MilB team level (High A, A, AA, AAA)}
#'   \item{league}{MilB team level (varies by level)}
#'   \item{city}{MilB team city/location}
#'   \item{name}{MilB team name}
#' }
#' @source <https://en.wikipedia.org/wiki/Minor_League_Baseball>
"milb"


#' Minoria Mechanism Table
#'
#' @description
#' This table mimics the structure of PEPFAR's MER Structured Datasets (MSD) for
#' mechanims, which originally originate from FACTInfo NextGen. The dummy
#' dataset for the (Kingdom of) Minoria has 120 (plus two dedup) mechanisms
#' available for use. Derived from `milb`.
#'
#' @format ## `minoria_mechs`
#' A data frame with 122 rows and 7 columns:
#' \describe{
#'   \item{mech_code}{Unique implementing mechanism code}
#'   \item{mech_name}{implementing mechanism code (from MiLB team name)}
#'   \item{prime_partner_name}{implementing mechanism partner (from MiLB team
#'     name)}
#' }
"minoria_mechs"

#' Minoria Geography Table
#'
#' @description
#' This table mimics the structure of PEPFAR's MER Structured Datasets (MSD).
#' The dummy dataset for the (Kingdom of) Minoria has four region (`snu1`), each
#' containing four districts (`psnu`). Derived from `milb`.
#'
#' @format ## `minoria_geo`
#' A data frame with 16 rows and 7 columns:
#' \describe{
#'   \item{operatingunit}{Operating Unit name (Minoria)}
#'   \item{operatingunituid}{OU unique ID (Minoria)}
#'   \item{country}{Country (Minoria)}
#'   \item{snu1}{Sub-National Unit 1 level below national (from MiLB league)}
#'   \item{snu1uid}{SNU1 unique ID}
#'   \item{cop22_psnu}{Priority SNU (from MiLB city)}
#'   \item{cop22_psnuuid}{PSNU unique ID}
#' }
"minoria_geo"

#' Minoria PSNU Shape File
#'
#' @description
#' This dataset is the sf file for mapping (Kingdom of) Minoria by PSNU.
#'
#' @family shp
#' @format ## `minoria_shp_psnu`
#' A data frame with 16 rows and 8 columns:
#' \describe{
#'   \item{psnu}{Priority SNU (from MiLB city)}
#'   \item{psnuuid}{PSNU unique ID}
#'   \item{snu1}{Sub-National Unit 1 level below national (from MiLB league)}
#'   \item{snu1uid}{SNU1 unique ID}
#'   \item{operatingunit}{Operating Unit name (Minoria)}
#'   \item{operatingunituid}{OU unique ID (Minoria)}
#'   \item{country}{Country (Minoria)}
#'   \item{geometry}{PSNU level polygon shape for mapping}
#' }
"minoria_shp_psnu"

#' Minoria PSNU Shape File
#'
#' @description
#' This dataset is the sf file for mapping (Kingdom of) Minoria by SNU1.
#'
#' @family shp
#' @format ## `minoria_shp_snu1`
#' A data frame with 4 rows and 6 columns:
#' \describe{
#'   \item{snu1uid}{SNU1 unique ID}
#'   \item{snu1}{Sub-National Unit 1 level below national (from MiLB league)}
#'   \item{operatingunit}{Operating Unit name (Minoria)}
#'   \item{operatingunituid}{OU unique ID (Minoria)}
#'   \item{country}{Country (Minoria)}
#'   \item{geometry}{SNU1 level polygon shape for mapping}
#' }
"minoria_shp_snu1"

#' Minoria PSNU Shape File
#'
#' @description
#' This dataset is the sf file for mapping (Kingdom of) Minoria at the national
#' level
#'
#' @family shp
#' @format ## `minoria_shp_ou`
#' A data frame with 16 rows and 7 columns:
#' \describe{
#'   \item{operatingunituid}{OU unique ID (Minoria)}
#'   \item{operatingunit}{Operating Unit name (Minoria)}
#'   \item{country}{Country (Minoria)}
#'   \item{geometry}{Country level polygon shape for mapping}
#' }
"minoria_shp_ou"
