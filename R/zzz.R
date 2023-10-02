.onAttach <- function(...) {
  if(requireNamespace("gagglr", quietly = TRUE))
    gagglr::oha_check("themask", suppress_success = TRUE)
}

utils::globalVariables(c(".","any_of", "caller_env", "df_msk", "fiscal_year",
                       "indicator", "mech_code", "mech_code_milb",
                       "mech_name_milb", "milb", "minoria_geo",
                       "prime_partner_name_milb", "psnuuid", "file_name",
                       "mtime"))
