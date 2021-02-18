#' @title Multiple Confusion Matrix data frame
#' @description a confusion matrix object for multi classification machine learning problems.
#' Returns the outputs of the matrix into a row structure for storage in a database or data frame.
#' @param caret_cm confusion matrix generated from the caret library
#'
#' @return returns a data frame containing the relevant confusion matrix statistics
#' @keywords internal
#' @import dplyr caret magrittr
#' @examples multi_class_cm(caret_cm)
#' @export


multi_class_cm <- function(caret_cm){

  if (class(caret_cm) != 'confusionMatrix'){
    stop("This function can only be used with confusionMatrix objects from the caret package")

  }

  cm <- caret_cm
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
  my_names <- as.character(colnames(cm$byClass))
  new_names_list <- list()
  for (name in 1:dvs){
    for(myname in 1:length(my_names)){
      named <- paste(class_labels[name],":")
      combined_names <- paste(named, my_names[myname])
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

  return(predict_new)
}
