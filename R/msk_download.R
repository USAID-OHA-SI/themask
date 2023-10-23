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
#' @family download
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
  piggyback::pb_download(NULL,
                         repo = "USAID-OHA-SI/themask",
                         tag = {tag},
                         dest = folderpath,
                         overwrite = TRUE)

  cli::cli_alert_success("The masked MSD has been downloaded to {.file {folderpath}}")

  if(launch == TRUE)
    shell.exec(folderpath)

}



#' Check the latest version available
#'
#' This function is used to check what masked version is currently available and
#' will flag if there it is up to date or you should run `msk_create` yourself.
#' It will also list all available historic releases that can be downloaded in
#' `msk_download` by specifying the version in the tag param.
#'
#' @family download
#' @export

msk_available <- function(){

  df_available <- piggyback::pb_list("USAID-OHA-SI/themask") %>%
    tibble::as_tibble() %>%
    dplyr::filter(stringr::str_detect(tag, "^20.*|latest")) %>%
    dplyr::select(file_name, tag)

  v_name <- df_available %>%
    dplyr::filter(tag == "latest") %>%
    dplyr::pull(file_name)

  v_base <- stringr::str_extract(v_name, "PSNU_IM_.*(?=.zip)")

  v_date <- stringr::str_extract(v_name, "[0-9]{8}") %>% as.Date("%Y%m%d")

  msd_latest_date <- glamr::pepfar_data_calendar %>%
    dplyr::filter(msd_release <= Sys.Date()) %>%
    dplyr::slice_tail() %>%
    dplyr::pull(entry_close) %>%
    as.Date()

  cli::cli_inform("The latest available masked dataset is {.file {v_base}}")

  all <- df_available %>%
    dplyr::mutate(base = stringr::str_extract(file_name, "PSNU_IM_.*(?=.zip)"),
                  date = file_name %>% stringr::str_extract("[0-9]{8}") %>% as.Date("%Y%m%d")) %>%
    dplyr::filter(tag != "latest") %>%
    dplyr::select(tag, base, date) %>%
    dplyr::arrange(dplyr::desc(date))

  cli::cli_inform("All available masked dataset for download:")
  tags <- all$tag
  tags <- tags %>% paste0(c(" [latest]", rep("", length(tags) - 1)))
  names(tags) <- c("v", rep("*", length(tags) - 1))
  cli::cli_bullets(tags)
  cli::cli_inform("By default, the latest file is downloaded but you can specify the version from above list in the {.field tag} param of {.fn msk_download}")

  if(v_date < msd_latest_date)
    cli::cli_warn("There is a newer MSD available to use. Try running
                  {.help [{.fun msk_create}](themask::msk_create)}")

}

