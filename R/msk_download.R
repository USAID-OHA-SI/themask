#' Download Masked Dataset
#'
#' This function download a masked dataset from GitHub
#' ([USAID-OHA-SI/themask](https://github.com/USAID-OHA-SI/themask)) for use in
#' training or testing. Recommend running `msk_available` to see what version
#' is available to download.
#'
#' @param folderpath where should the file be downloaded to?
#' @param tag version tag, default = "latest"
#' @param launch whether to launch Windows Explorer to the location after the
#'   download completes (default = FALSE)
#'
#' @export
#' @references msk_available
#'
#' @examples \dontrun{
#' #check available version
#' msk_available()
#'
#' #download to your downloads folder
#' msk_download("~/Downloads)
#' }
#' \dontrun{
#' #download an older version
#' msk_download("~/Downloads, tag = "2023.06.27c")
#' }
msk_download <- function(folderpath, tag = "latest", launch = FALSE){

  if(missing(folderpath))
    cli::cli_abort("Specify the {.arg folderpath} of where to download the dataset")

  #list files
  files <- piggyback::pb_list("USAID-OHA-SI/themask",
                              tag = {tag}) %>%
    dplyr::pull(file_name)

  #download files
  piggyback::pb_download(files,
                         dest = folderpath,
                         overwrite = TRUE)

  cli::cli_inform("The masked MSD has been downloaded to {.file {folderpath}}")

  if(launch == TRUE)
    shell.exec(folderpath)

}



#' Check the latest version available
#'
#' This function is used to check what masked version is currently avaiable and
#' will flag if there it is up to date or you should run `msk_create` yourself.
#'
#' @export

msk_available <- function(){
  v_name <- piggyback::pb_list("USAID-OHA-SI/themask",
                     tag = {tag}) %>%
    dplyr::pull(file_name)

  v_base <- stringr::str_extract(v_name, "PSNU_IM_.*(?=.zip)")

  v_date <- stringr::str_extract(v_name, "[0-9]{8}") %>% as.Date("%Y%m%d")

  msd_latest_date <- glamr::pepfar_data_calendar %>%
    dplyr::filter(msd_release <= Sys.Date()) %>%
    dplyr::slice_tail() %>%
    dplyr::pull(entry_close) %>%
    as.Date()

  cli::cli_inform("The latest available masked dataset is {.file {v_base}}")

  if(v_date < msd_latest_date)
    cli::cli_warn("There is a newer MSD available to use. Try running
                  {.help [{.fun msk_create}](themask::msk_create)}")

}

