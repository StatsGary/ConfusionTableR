#' @title Multiple Confusion Matrix data frame
#' @description a confusion matrix object for multiple outcome classification machine learning problems.
#' @param train_labels the classification labels from the training set
#' @param truth_labels the testing set ground truth labels for comparison
#' @param ... function forwarding for passing mode and other parameters to `caret` confusionMatrix
#' @return A list containing the outputs highlighted hereunder:
#' \itemize{
#' \item{\strong{"confusion_matrix"}}{ a confusion matrix list item with all the associated confusion matrix statistics}
#' \item{\strong{"record_level_cm"}}{ a row by row data.frame version of the above output, to allow for storage in databases and row by row for tracking ML model performance}
#' \item{\strong{"cm_tbl"}}{ a confusion matrix raw table of the values in the matrix}
#' \item{\strong{"last_run"}}{datetime object storing when the function was run}
#' }
#' @importFrom caret confusionMatrix createDataPartition
#' @importFrom dplyr select
#' @examples
#' # Get the IRIS data as this is a famous multi-classification problem
#' library(caret)
#' library(ConfusionTableR)
#' library(randomForest)
#' df <- iris
#' df <- na.omit(df)
#' table(iris$Species)
#' # Create a training / test split
#' train_split_idx <- caret::createDataPartition(df$Species, p = 0.75, list = FALSE)
#' # Here we define a split index and we are now going to use a multiclass ML model to fit the data
#' train <- df[train_split_idx, ]
#' test <- df[-train_split_idx, ]
#'# Fit a random forest model on the data
#' rf_model <- caret::train(Species ~ .,data = df,method = "rf", metric = "Accuracy")
#' # Predict the values on the test hold out set
#' rf_class <- predict(rf_model, newdata = test, type = "raw")
#' predictions <- cbind(data.frame(train_preds=rf_class, test$Species))
#'# Use ConfusionTableR to create a row level output
#' cm <- ConfusionTableR::multi_class_cm(predictions$train_preds, predictions$test.Species)
#'# Create the row level output
#' cm_rl <- cm$record_level_cm
#' print(cm_rl)
#'#Expose the original confusion matrix list
#' cm_orig <- cm$confusion_matrix
#' print(cm_orig)
#' @export


multi_class_cm <- function(train_labels, truth_labels, ...){

  cm <- caret::confusionMatrix(train_labels, truth_labels, ...)
  cm_table <- cm$table
  class_labels <- as.character(colnames(cm$table))
  dvs <- length(class_labels)

  names_list <- list()
  for (i in 1:dvs){
    for (j in 1:dvs){
      nametmp <- paste(colnames(cm$table)[i], ":", rownames(cm$table)[j])
      names_list <- cbind(names_list, nametmp)
    }
  }

  names_new <- t(unlist(names_list))

  new_item <- list()
  temp_new <- list()
  for (col in 1:dvs){
    temp <- t(cm$table)[col,1:dvs]
    temp_new <- cbind(temp_new, temp)

  }
  predict_new <- data.frame(t(unlist(temp_new)))
  colnames(predict_new) <- names_new

  # Flattens the data out for multiclass summaries
  predict_new <- cbind(predict_new, t(cm$overall))

  # Do the same looping the descriptions
  curr_names <- as.character(colnames(cm$byClass))
  new_names_list <- list()
  for (name in 1:dvs){
    for(myname in 1:length(curr_names)){
      named <- paste(class_labels[name],":")
      combined_names <- paste(named, curr_names[myname])
      temp <- combined_names
      new_names_list <- cbind(new_names_list, combined_names)
    }
  }

  combined_names <- as.character(unlist(new_names_list))
  summary_list <- list()
  for (col in 1:dvs){
    temp <- unlist(cm$byClass)[col,]
    summary_list <- cbind(summary_list, temp)

  }
  summary_new <- data.frame(t(unlist(summary_list)))
  colnames(summary_new) <- combined_names

  # Bind the summaries on to the new data

  predict_new <- cbind(predict_new, summary_new)
  predict_new$cm_ts <- Sys.time()
  # Compile results
  results_list <- list("confusion_matrix" = cm,
                       "record_level_cm" = predict_new,
                       "cm_tbl" = cm_table,
                       "last_run"=Sys.time())
  return(results_list)
}





