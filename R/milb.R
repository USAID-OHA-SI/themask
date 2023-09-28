#' MiLB Information Table
#'
#' This table has been extracted from Wikipedia's Minor League Baseball (MiLB)
#' page and is used for masking geographic and partner information in PEPFAR's
#' MER Structured Datasets (MSD).
#'
#' @format ## `milb_tbl`
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
"milb_tbl"
