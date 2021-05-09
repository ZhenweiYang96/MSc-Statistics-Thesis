######################################################################################
############# LBA-NN Implementation on Example 1
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
############# linear data - one variable
######################################################################################
# load data
train <- read.csv("Data/traindata_1.csv") # training
test <- read.csv("Data/testdata_1.csv") # test

test_x <- evm.test(y ~ P, newdata = test, trainingset = train) # input data matrix for the test set
test_y <- rvm.test(y ~ P, newdata = test, trainingset = train) # output data matrix for the test set

#################################### Set LBA-NN 
# build the model
set_random_seed(10)  # seed 
lbann.model <- lbann(y ~ P, data = train, num.neurons = 8, epochs = 50, 
                     activation.1 = "relu", activation.2 = "softmax",  
                     val_split.ratio = 0, lr = 0.01, K =3)

#################################### qualitative evaluation
# Importance plot
lbann.model$importance.plot
ggsave("Output/fig3_importance_plot_example_1.png")

# LBA-NN-K-means
lbann.model$biplot
ggsave("Output/fig4_biplot_example_1.png")

#################################### quantitative evaluation
## mean sqaure error
mse <- lbann.model$model %>% keras::evaluate(test_x, test_y) # mse = 0.07
mse

## accuracy + precision + recall + specificity + f1-score
# Confusion matrix result
y_pred.lbann <- predict(lbann.model$model, x = test_x) # predicted Y
y_pred.lbann <- apply(y_pred.lbann, 1, function(x) {colnames(lbann.model$output.matrix)[which.max(x)]}) # predicted class
cm <- confusionMatrix(table(predict = y_pred.lbann, true = test$y)) # summary: accuracy = 0.75
acc <- as.matrix(cm,what="overall")[1]
var <- c("Pos Pred Value","Recall", "Specificity", "F1") # all indicators
cm <- as.matrix(cm, what = "classes")[var,] # extract used indicators
cm.sum <- data.frame(LBANN = round(c(mse[1], acc, apply(cm, 1, mean)),2))
row.names(cm.sum) <- c("mean square error","accuracy", "precision", "recall", "specificity", "f1-score")
write.csv(cm.sum, "Output/tab5_1_summary_prediction_lbann.csv") # table 5 (LBA part: summary of the performance)

# draw the confusion matrix
eval <- cvms::evaluate(
  data = data.frame(predict = as.character(y_pred.lbann), true = as.character(test$y)),
  target_col = "true",
  prediction_cols = "predict",
  type = "multinomial"
)
png("Output/fig5a_confusion_matrix_lbann.png")
plot_confusion_matrix(eval)
dev.off()

