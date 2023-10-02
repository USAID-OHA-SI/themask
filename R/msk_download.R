#' Download Masked Dataset
#'
#' This function download a masked dataset from GitHub
#' ([USAID-OHA-SI/themask](https://github.com/USAID-OHA-SI/themask)) for use in
#' training or testing.
#'
#' @param folderpath where should the file be downloaded to?
#' @param tag version tag, default = "latest"
#' @param launch whether to launch Windows Explorer to the location after the
#'   download completes (default = FALSE)
#'
#' @export
#'
#' @examples \dontrun{
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
