#' @title Variable importance - var_impeR
#' @description takes the outputs of the caret package to create variable importance plots.
#' @param model a trained caret model you want to create a variable importance summary of
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate select arrange
#' @importFrom tibble rownames_to_column rowid_to_column as_tibble tibble
#' @importFrom caret varImp
#' @references ggplot2
#' @examples var_impeR(model) #Trained ML model from caret library
#' @return A list with tibble and ggplot object inside
#' \itemize{
#'   \item rowid - an ordered row index
#'   \item Metric - the variable importance metric
#'   \item Overall - the variable importance weight relating to mean decrease in accuracy
#'   \item Prop - the proportion of the variable importance weight over all importance metrics
#'   \item Generated - when the variable importance plot was run
#' }
#' @export
var_impeR <- function(model){

  model <- caret::varImp(model)$importance
  model <- as.data.frame(model) %>%
    rownames_to_column(var = "Metric") %>%
    rowid_to_column(var = "rowid") %>%
    dplyr::mutate(Prop = Overall / sum(Overall),
                  Model.Used = model$method,
                  generated = Sys.time()) %>%
    as_tibble()

  # Create plot
  plot <- model %>%
    ggplot(aes(x=reorder(Metric, Overall),
               y=Overall,
               label = Metric)) +
    geom_point(stat="identity", aes(colour = factor(Overall)), size = 6) +
    coord_flip() + theme_minimal() +
    theme(legend.position = "none") +
    labs(title="Global variable importance", x = "Metric", y="Overall Importance")


  model_list <- list("model" = model,
                     "glob_var_imp_plot" = plot)

  return(model_list)
}
