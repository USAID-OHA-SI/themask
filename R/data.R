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


#' Minoria Geography Table
#'
#' @description
#' This table mimics the structuere of PEPFAR's MER Structured Datasets (MSD).
#' The dummy dataset for the (Kingdom of) Minoria has four region (`snu1`), each
#' containing four districts (`psnu`). Derived from `milb`.
#'
#' @format ## `minoria_geo`
#' A data frame with 16 rows and 7 columns:
#' \describe{
#'   \item{operatingunit_milb}{Operating Unit name (Minoria)}
#'   \item{operatingunituid_milb}{OU unique ID (Minoria)}
#'   \item{country_milb}{Country (Minoria)}
#'   \item{snu1_milb}{Sub-National Unit 1 level below national (from MiLB league)}
#'   \item{snu1uid_milb}{SNU1 unique ID}
#'   \item{psnu_milb}{Priority SNU (from MiLB city)}
#'   \item{psnu_milb}{PSNU unique ID}
#' }
"minoria_geo"
