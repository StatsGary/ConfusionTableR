## ---- include = FALSE, echo=FALSE---------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.height= 5, 
  fig.width=7
)

## ----getcaretdata, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----
library(ggplot2)
library(caret)
library(caretEnsemble)
library(scales)
library(mltools)
library(mlbench)

# Load in the iris data set for this problem 
data(iris)
df <- iris
# View the class distribution, as this is a multiclass problem, we can use the multi classification data table builder
table(iris$Species)
ggplot(data = iris,
       aes(x=Species)) + geom_bar(aes(fill = Species), show.legend = FALSE) + theme_minimal()
# We can see we have a balanced dataset. I will now create a simple test and train split on the data



## ----split_data, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----
train_split_idx <- caret::createDataPartition(df$Species, p = 0.75, list = FALSE)
# Here we define a split index and we are now going to use a multiclass ML model to fit the data
data_TRAIN <- df[train_split_idx, ]
data_TEST <- df[-train_split_idx, ]
str(data_TRAIN)


## ----train_data, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----
rf_model <- caret::train(Species ~ .,
                         data = df,
                         method = "rf",
                         metric = "Accuracy")

rf_model


## ----conf_mat, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----
# Make a prediction on the fitted model with the test data
rf_class <- predict(rf_model, newdata = data_TEST, type = "raw") 

# Create a confusion matrix object
cm <- confusionMatrix(rf_class,
                      data_TEST[,names(data_TEST) %in% c("Species")])

print(cm) 
typeof(cm)

## ----using_multi_function, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----
# Implementing function to collapse data

library(ConfusionTableR)
mc_df <- ConfusionTableR::multi_class_cm(cm)
print(mc_df)
names(mc_df)
class(mc_df) # This has now been converted to a data frame


## ----load_cancer, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----
# Implementing function to collapse data
data("BreastCancer", package = "mlbench")
#Use complete cases of breast cancer
breast <- BreastCancer[complete.cases(BreastCancer), ] #Create a copy
breast <- breast[, -1]
# The ML bench data shows the data in the mlbench package - this allows for a binary classification of benign vs malignant. We will use this for our ML model
breast$Class <- factor(breast$Class) # Create as factor
for(i in 1:9) {
  breast[, i] <- as.numeric(as.character(breast[, i]))
}

# Train a ML model to fit to it
# Split the data
train_split_idx <- caret::createDataPartition(breast$Class, p = 0.75, list = FALSE)
# Here we define a split index and we are now going to use a multiclass ML model to fit the data
data_TRAIN <- breast[train_split_idx, ]
data_TEST <- breast[-train_split_idx, ]
# Fit a logistic regression model
glm_model <- train(Class ~ Cl.thickness + Cell.size + Cell.shape + Marg.adhesion +                Normal.nucleoli,
                   data = data_TRAIN,
                   method = "glm",
                   family = "binomial")

glm_model



## ----predict_cm, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----
glm_class <- predict(glm_model, newdata = data_TEST, type = "raw") 

# Create a confusion matrix object
cm <- confusionMatrix(glm_class,
                      data_TEST[,names(data_TEST) %in% c("Class")])

print(cm)



## ----binary_df, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----

names(ConfusionTableR::binary_class_cm(cm))
print(ConfusionTableR::binary_class_cm(cm))


## ----visual_confusion_matrix, warning=FALSE, error=FALSE, message=FALSE, fig.height= 5, fig.width=7----

ConfusionTableR::binary_visualiseR(
  cm_input = cm, class_label1 = "Benign", class_label2 = "Malignant",
  quadrant_col1 = "#28ACB4", quadrant_col2 = "#4397D2", 
  custom_title = "Breast Cancer Confusion Matrix", text_col= "black"
)



