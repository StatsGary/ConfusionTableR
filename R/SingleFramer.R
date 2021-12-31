#' @title Binary Confusion Matrix data frame
#' @description a confusion matrix object for binary classification machine learning problems.
#' @param train_labels the classification labels from the training set
#' @param truth_labels the testing set ground truth labels for comparison
#' @param ... function forwarding for additional `caret` confusion matrix parameters to be passed such as mode="everything" and positive="class label"
#' @return A list containing the outputs highlighted hereunder:
#' \itemize{
#' \item{\strong{"confusion_matrix"}}{ a confusion matrix list item with all the associated confusion matrix statistics}
#' \item{\strong{"record_level_cm"}}{ a row by row data.frame version of the above output, to allow for storage in databases and row by row for tracking ML model performance}
#' \item{\strong{"cm_tbl"}}{ a confusion matrix raw table of the values in the matrix}
#' \item{\strong{"last_run"}}{datetime object storing when the function was run}
#' }
#' @importFrom dplyr select
#' @importFrom caret confusionMatrix createDataPartition
#' @examples
#' library(dplyr)
#' library(ConfusionTableR)
#' library(caret)
#' library(tidyr)
#' library(mlbench)
#'
#' # Load in the data
#'data("BreastCancer", package = "mlbench")
#'breast <- BreastCancer[complete.cases(BreastCancer), ] #Create a copy
#'breast <- breast[, -1]
#'breast <- breast[1:100,]
#'breast$Class <- factor(breast$Class) # Create as factor
#'for(i in 1:9) {
#'  breast[, i] <- as.numeric(as.character(breast[, i]))
#'}
#'
#' #Perform train / test split on the data
#' train_split_idx <- caret::createDataPartition(breast$Class, p = 0.75, list = FALSE)
#' train <- breast[train_split_idx, ]
#' test <- breast[-train_split_idx, ]
#' rf_fit <- caret::train(Class ~ ., data=train, method="rf")
#' #Make predictions to expose class labels
#' preds <- predict(rf_fit, newdata=test, type="raw")
#' predicted <- cbind(data.frame(class_preds=preds), test)
#'
#' #ConfusionTableR to produce record level output
#' cm <- ConfusionTableR::binary_class_cm(predicted$class_preds,predicted$Class)
#' # Other modes here are mode="prec_recall", mode="sens_spec" and mode="everything"
#' # Record level output
#' cm$record_level_cm #Primed for storage in a database table
#' # List confusion matrix
#' cm$confusion_matrix
#' @export


binary_class_cm <- function(train_labels, truth_labels, ...){
  message("[INFO] Building a record level confusion matrix to store in dataset")
  #Instantiate the confusion matrix obj...
  cm <- caret::confusionMatrix(train_labels, truth_labels, ...)
  #Extract the list element
  cm_table <- data.frame(cm$table)
  #Paste the predicted label on
  cm_table$PredLabel <- paste0("Pred_", cm_table$Prediction, "_Ref_", cm_table$Reference)
  cm_table <- dplyr::select(cm_table, PredLabel, Freq)
  cm_tbl <- data.frame(t(cm_table$Freq))
  colnames(cm_tbl) <- t(cm_table$PredLabel)
  cm_df <- data.frame(cbind(cm_tbl, t(cm$overall),t(cm$byClass)))
  cm_df$cm_ts <- Sys.time()
  results_list <- list("confusion_matrix" = cm,
                       "record_level_cm" = data.frame(cm_df),
                       "cm_tbl" = cm_table,"last_run"=Sys.time())

  message("[INFO] Build finished and to expose record level cm use the record_level_cm list item")

  return(results_list)
}



