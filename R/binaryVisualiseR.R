#' @title Binary Visualiser - A Binary Confusion Matrix Visual
#' @description a confusion matrix object for binary classification machine learning problems.
#' Returns a plot to visualise the important statistics derived from a confusion matrix, see: \url{https://machinelearningmastery.com/confusion-matrix-machine-learning/}.
#' @param train_labels the classification labels from the training set
#' @param truth_labels the testing set ground truth labels for comparison
#' @param class_label1 classification label 1 i.e. readmission into hospital
#' @param class_label2 classification label 2 i.e. not a readmission into hospital
#' @param quadrant_col1 colour of the first quadrant - specified as hexadecimal
#' @param quadrant_col2 colour of the second quadrant - specified as hexadecimal
#' @param custom_title title of the confusion matrix plot
#' @param info_box_title title of the confusion matrix statistics box
#' @param text_col the colour of the text
#' @param round_dig rounding options
#' @param cm_stat_size the cex size of the statistics box label
#' @param cm_stat_lbl_size the cex size of the label in the statistics box
#' @param ... function forwarding to the confusion matrix object to pass additional args, such as positive = "Class label"
#' @return returns a visual of a Confusion Matrix output
#' @importFrom caret confusionMatrix createDataPartition
#' @importFrom graphics par rect text layout title plot
#' @examples
#' library(dplyr)
#' library(ConfusionTableR)
#' library(caret)
#' library(tidyr)
#' library(mlbench)
#'
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
#' # Create the visual
#' ConfusionTableR::binary_visualiseR(predicted$class_preds, predicted$Class)
#' @export


binary_visualiseR <- function(train_labels,truth_labels, class_label1="Class Negative",
                              class_label2="Class Positive", quadrant_col1='#3F97D0',
                              quadrant_col2='#F7AD50', custom_title="Confusion matrix",
                              info_box_title="Confusion matrix statistics",
                              text_col="black", round_dig=2,
                              cm_stat_size=1.4, cm_stat_lbl_size=1.5, ...){

  cm <- caret::confusionMatrix(train_labels, truth_labels, ...)
  #Define globals
  layout(matrix(c(1,1,2)))
  plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
  #n is specified in plot to indicate no plotting
  title(custom_title, cex.main=2)
  # Create the matrix visualisation using custom rectangles and text items on the chart
  rect(150, 430, 240, 370, col=quadrant_col1)
  text(195, 435, class_label1, cex=1.2)
  rect(250, 430, 340, 370, col=quadrant_col2)
  text(295, 435, class_label2, cex=1.2)
  text(125, 370, 'Predicted', cex=1.3, srt=90, font=2)
  text(245, 450, 'Actual', cex=1.3, font=2)
  rect(150, 305, 240, 365, col=quadrant_col1)
  rect(250, 305, 340, 365, col=quadrant_col2)
  text(140, 400, class_label1, cex=1.2, srt=90)
  text(140, 335, class_label2, cex=1.2, srt=90)

  #Add the results of the confusion matrix - as these will be saved to cm$table
  result <- as.numeric(cm$table)
  text(195, 400, result[1], cex=1.6, font=2, col=text_col)
  text(195, 335, result[2], cex=1.6, font=2, col=text_col)
  text(295, 400, result[3], cex=1.6, font=2, col=text_col)
  text(295, 335, result[4], cex=1.6, font=2, col=text_col)

  #Add in other confusion matrix statistics
  plot(c(100, 0), c(100, 0), type = "n", xlab="", ylab="", main = info_box_title, xaxt='n', yaxt='n')
  text(10, 85, names(cm$byClass[1]), cex=cm_stat_lbl_size, font=1)
  text(10, 70, round(as.numeric(cm$byClass[1]), round_dig), cex=cm_stat_size)
  text(30, 85, names(cm$byClass[2]), cex=cm_stat_lbl_size, font=1)
  text(30, 70, round(as.numeric(cm$byClass[2]), round_dig), cex=cm_stat_size)
  text(50, 85, names(cm$byClass[5]), cex=cm_stat_lbl_size, font=1)
  text(50, 70, round(as.numeric(cm$byClass[5]), round_dig), cex=cm_stat_size)
  text(65, 85, names(cm$byClass[6]), cex=cm_stat_lbl_size, font=1)
  text(65, 70, round(as.numeric(cm$byClass[6]), round_dig), cex=cm_stat_size)
  text(86, 85, names(cm$byClass['Balanced Accuracy']), cex=cm_stat_lbl_size, font=1)
  text(86, 70, round(as.numeric(cm$byClass['Balanced Accuracy']), round_dig), cex=cm_stat_size)


  # add in the accuracy information
  text(30, 35, names(cm$overall[1]), cex=cm_stat_lbl_size, font=1)
  text(30, 20, round(as.numeric(cm$overall[1]), round_dig), cex=cm_stat_size)
  text(70, 35, names(cm$overall[2]), cex=cm_stat_lbl_size, font=1)
  text(70, 20, round(as.numeric(cm$overall[2]), round_dig), cex=cm_stat_size)

}







