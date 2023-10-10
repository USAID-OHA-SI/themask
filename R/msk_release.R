#' Upload a New Masked Dataset to GitHub
#'
#' This function is used to upload the new masked dataset to GitHub
#' (USAID-OHA-SI/themask) so that others can use it. This function is for
#' package developers use only. The data from [`msk_create()`] are subset to
#' 16 PSNUs and masked across geographic and mechanism variables. Either the
#' PSNUxIM or NAT_SUBNAT Structured Datasets can be masked.
#'
#' @param filepath path to the PSD file (PSNUxIM or NAT_SUBNAT) or masked file
#' @param output_folder location where you want to store the new file (default
#'  does not save the file)
#'
#' @return dataframe with converted geography + mech info
#' @export
#' @references msk_create
#'
#' @examples \dontrun{
#' #create and upload a new release
#' library(glamr)
#' library(themask)
#'
#' #store path to latest MSD
#' path <- si_path() %>% return_latest("PSNU_IM")
#'
#' #create a masked dataset from the PSNUxIM MSD
#' msk_release(path, "project1/data")
#' }
#' \dontrun{
#' #upload release from an existing masked dataset
#' library(glamr)
#' library(themask)
#'
#' #store path to masked dataset
#' path_msk <- return_latest("project1/data","TRAINING")
#'
#' #create a masked dataset from the PSNUxIM MSD
#' msk_release(path_msk)
#' }

msk_release <- function(filepath, output_folder){

  #fill with default path to PSNUxIM if not provided
  if(missing(filepath))
    filepath <- glamr::si_path() %>% glamr::return_latest("PSNU_IM")

  #fill with temp dir path if not provided
  if(missing(output_folder))
    output_folder <- tempdir()

  #release version tag
  tag_name <- filepath %>%
    stringr::str_extract("[0-9]{8}_v[0-9]*") %>%
    stringr::str_sub(c(1, 5, 7, 9), c(4, 6, 8, 11)) %>%
    paste(collapse = ".") %>%
    stringr::str_replace("_v1", "i") %>%
    stringr::str_replace("_v2", "c")

  #if the filepath is not a masked file, create one
  if(!grepl("TRAINING", filepath)){

    msk_create(filepath, output_folder)

    filepath <- output_folder %>%
      list.files("TRAINING", full.names = TRUE) %>%
      file.info() %>%
      tibble::rownames_to_column(var = "filepath") %>%
      dplyr::filter(mtime == max(mtime)) %>%
      dplyr::pull(filepath)
  }

  #upload new masked file to GH
  piggyback::pb_new_release(repo = "USAID-OHA-SI/themask", tag = tag_name)

  piggyback::pb_upload(filepath,
                       "USAID-OHA-SI/themask",
                       tag = tag_name)

  #upload, overwriting the "latest" version
  piggyback::pb_upload(filepath,
                       "USAID-OHA-SI/themask",
                       overwrite = TRUE,
                       tag = "latest")
}
