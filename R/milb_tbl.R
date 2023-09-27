#' MiLB to PEPFAR Geographic + Mechanisms Mapping Table
#'
#' This table has been extracted from Wikipedia's Minor League Baseball page and
#' is used for masking geographic and partner information in PEPFAR's MER
#' Structured Datasets (MSD).
#'
#' @format ## `milb_tbl`
#' A data frame with 120 rows and 7 columns:
#' \describe{
#'   \item{operatingunit_milb}{Operating Unit}
#'   \item{country_milb}{Country}
#'   \item{snu1_milb}{Sub-National Unit 1 level below national (from MiLB league)}
#'   \item{psnu_milb}{Priority SNU (from MiLB city)}
#'   \item{mech_name_milb}{Implementing Mechanism Name (from MiLB team name)}
#'   \item{prime_partner_name_milb}{Implementing Partner (from MiLB team name)}
#'   \item{mech_code_milb}{Mechanism Code}
#' }
#' @source <https://en.wikipedia.org/wiki/Minor_League_Baseball>
"milb_tbl"
