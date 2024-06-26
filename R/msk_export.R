#' Export masked dataset
#'
#' @param df df
#' @param filepath path to the PSD file (PSNUxIM or NAT_SUBNAT)
#' @param output_folder location where you want to store the new file
#'
#' @keywords internal
#' @importFrom utils zip

msk_export <- function(df, filepath, output_folder){

  #print dataset if not exported
  if(missing(output_folder))
    return(df)

  #create filename for output
    output_filename <- msk_filename(df, filepath)

    output_filepath <- file.path(output_folder, output_filename)
    output_filepath_zip <- stringr::str_replace(output_filepath, "txt", "zip")

    readr::write_tsv(df, output_filepath, progress = FALSE)

    #zip txt file
    suppressMessages(
      zip(output_filepath_zip, output_filepath, extras = "-j")
    )

    #remove csv (keeping zipped file)
    unlink(output_filepath)

    cli::cli_alert_success("You have output a new masked dataset in {.file {output_folder}}.")


}


#' Create a file name for export
#'
#' @param df df
#' @param filepath path to the PSD file (PSNUxIM or NAT_SUBNAT)
#'
#' @keywords internal

msk_filename <- function(df, filepath){

  #masked year for
  v_yr <- df %>%
    dplyr::distinct(fiscal_year) %>%
    dplyr::arrange(fiscal_year) %>%
    dplyr::filter(fiscal_year == min(fiscal_year) | fiscal_year == max(fiscal_year)) %>%
    dplyr::mutate(fiscal_year = stringr::str_remove(fiscal_year, "20")) %>%
    dplyr::pull() %>%
    paste0(collapse = "-") %>%
    paste0("FY", .)

  #export
  output_filename <- filepath %>%
    basename() %>%
    stringr::str_replace("Structured_Dataset", "Structured_TRAINING_Dataset") %>%
    stringr::str_replace("FY.*(?=_20)", v_yr) %>%
    stringr::str_replace("zip", "txt")

  return(output_filename)
}
