######################################################################################
############# LBA-NN Implementation on Example 3
######################################################################################
rm(list=ls())

######################################################################################
# before all
# please install all the packages below
# for the lbann from us, please use the following codes:
# library(devtools)
# devtools::install_github("https://github.com/ZhenweiYang96/lbann")
######################################################################################

# Load packages and functions
source("Script/4. function.R")
library(tensorflow)
library(lbann)
library(keras)
library(tidyverse)
library(caret)
library(cvms)

######################################################################################
############# Previous data in "constrained LBA"
######################################################################################
# load data
train <- read.csv("Data/traindata_3.csv") # training
test <- read.csv("Data/testdata_3.csv") # test

test_x <- evm.test(cause.of.death ~ gender + age, 
                   newdata = test, trainingset = train) # input data matrix for the test set
test_y <- rvm.test(cause.of.death ~ gender + age,
                   newdata = test, trainingset = train) # output data matrix for the test set

#################################### Set LBA-NN 
# build the model
set_random_seed(123)  # seed 
lbann.model <- lbann(cause.of.death ~ gender + age, 
                     data = train, num.neurons = 32, epochs = 50,
                     activation.1 = "relu", activation.2 = "softmax",
                     lr = 0.0001,
                     val_split.ratio = 0, K = 3)

#################################### qualitative evaluation
# Importance plot
lbann.model$importance.plot
ggsave("Output/figS1_importance_plot_example_3.png")

# LBA-NN-K-means
lbann.model$biplot
ggsave("Output/figS2_biplot_example_3.png")

#################################### quantitative evaluation
## mean sqaure error
mse <- lbann.model$model %>% keras::evaluate(test_x, test_y) # mse = 0.08
mse

## accuracy + precision + recall + specificity + f1-score
# Confusion matrix result
y_pred.lbann <- predict(lbann.model$model, x = test_x) # predicted Y
y_pred.lbann <- apply(y_pred.lbann, 1, function(x) {colnames(lbann.model$output.matrix)[which.max(x)]}) # predicted class
cm <- confusionMatrix(as.factor(y_pred.lbann), reference = as.factor(test$cause.of.death))  # summary: accuracy = 0.43
acc <- as.matrix(cm,what="overall")[1]
var <- c("Pos Pred Value","Recall", "Specificity", "F1") # all indicators
cm <- as.matrix(cm, what = "classes")[var,] # extract used indicators
cm.sum <- data.frame(LBANN = round(c(mse[1], acc, apply(cm, 1, mean)),2))
row.names(cm.sum) <- c("mean square error","accuracy", "precision", "recall", "specificity", "f1-score")
write.csv(cm.sum, "Output/tabS4_1_summary_prediction_lbann.csv") # table S4 (LBANN part: summary of the performance)

# draw the confusion matrix
eval <- cvms::evaluate(
  data = data.frame(predict = as.character(y_pred.lbann), true = as.character(test$cause.of.death)),
  target_col = "true",
  prediction_cols = "predict",
  type = "multinomial"
)
png("Output/figS3a_confusion_matrix_lbann.png")
plot_confusion_matrix(eval)
dev.off()

