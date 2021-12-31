#' @title Dummy Encoder function to encode multiple columns at once
#' @description This function has been designed to encode multiple columns at once and allows
#' the user to specify whether to drop the reference columns or retain them in the data
#' @param df - data.frame object to pass to the function
#' @param columns - vector of columns to be encoded for dummy encoding
#' @param map_fn - choice of mapping function purrr:map or furr::future_map accepted
#' @param remove_original - remove the variables that the dummy encodings are based off
#' @importFrom dplyr mutate select select_if tibble inner_join one_of
#' @importFrom magrittr %>%
#' @importFrom purrr reduce map
#' @importFrom furrr future_map
#' @importFrom tidyr spread
#' @return A tibble containing the dummy encodings
#' @export
#' @examples
#' \dontrun{
#' #Use the NHSR stranded dataset
#' df <- NHSRdatasets::stranded_data
#' #Create a function to select categorical variables
#'sep_categorical <- function(df){
#'  cats <- df %>%
#'    dplyr::select_if(is.character)
#'  return(cats)
#'}
#'cats <- sep_categorical(df) %>%
#'  dplyr::select(-c(admit_date))
#'#Dummy encoding
#'columns_vector <- c(names(cats))
#'dummy_encodings <- dummy_encoder(cats, columns_vector)
#'glimpse(dummy_encodings)
#'}


dummy_encoder <- function(df, columns, map_fn = furrr::future_map, remove_original=TRUE) {

  column_list_dummy <- function(column_list) {
    df <- df %>%
      dplyr::mutate(row=seq.int(nrow(.))) %>%
      dplyr::mutate_at(column_list, ~ paste(column_list,
                                            eval(as.symbol(column_list)),
                                            sep = "_")) %>%
      dplyr::mutate(encoding_val = 1) %>%
      tidyr::spread(key = column_list, value = encoding_val, fill = 0)

    return(df)

  }

  df <- map_fn(columns, column_list_dummy) %>%
    purrr::reduce(inner_join) %>%
    dplyr::select(-row)


  if (remove_original == TRUE){
    df <- df %>%
      dplyr::select(!one_of(columns))
  }


  return(dplyr::tibble(df))

}


