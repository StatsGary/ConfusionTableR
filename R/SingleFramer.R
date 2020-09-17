#' @title Binary Confusion Matrix data frame
#' @description a confusion matrix object for binary classification machine learning problems.
#'
#' @param cm confusion matrix generated from the caret library
#'
#' @return returns a data frame containing the relevant confusion matrix statistics
#' @keywords internal
#' @import dplyr caret magrittr
#' @examples binary_class_cm(cm)
#' @export


## quiets concerns of R CMD check re: the .'s that appear in pipelines
#if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))


binary_class_cm <- function(cm){
  if (class(cm) != 'confusionMatrix'){
    stop("This function can only be used with confusionMatrix objects from the caret package")

  }
  cm_table <- data.frame(cm$table)
  cm_table %<>%
    dplyr::mutate(PredLabel = paste0("Pred_", cm_table$Prediction, "_Ref_", cm_table$Reference)) %>%
    dplyr::select(PredLabel, Freq)

  cm_tbl <- data.frame(t(cm_table$Freq))
  colnames(cm_tbl) <- t(cm_table$PredLabel)

  cm_df <- data.frame(cbind(cm_tbl, t(cm$overall),t(cm$byClass))) %>%
    mutate(cm_ts=Sys.time())

  return(cm_df)
}



