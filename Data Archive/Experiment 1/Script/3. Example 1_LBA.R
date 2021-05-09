######################################################################################
############# LBA Implementation on Example 1
######################################################################################
rm(list=ls())

# Load packages and functions
source("Script/4. function.R")
library(lba)
library(tidyverse)
library(caret)
library(cvms)

######################################################################################
############# linear data - one variable
######################################################################################
# load data
train <- read.csv("Data/traindata_1.csv") # training
test <- read.csv("Data/testdata_1.csv") # test
data <- read.csv("Data/data_1.csv")

test_x <- evm.test(y ~ P, newdata = test, trainingset = train) # input data matrix for the test set
test_y <- rvm.test(y ~ P, newdata = test, trainingset = train) # output data matrix for the test set

### contingency table
contable <- table(data$P, data$y)
write.csv(contable, "Output/tab3_contingency_table_example1.csv") # table 3: contingency table of the data

#################################### LBA
set.seed(1)
lba.model <- lba(y ~ P, data = train, K = 3, method = "mle", trace.lba = F) # build LBA with 3 latent budgets

#################################### qualitative evaluation
write.csv(round(lba.model$A, 2), "Output/tab4_1_mixing parameters A.csv")
write.csv(round(lba.model$B, 2), "Output/tab4_2_latent budgets B.csv")


#################################### quantitative evaluation
y_pred.lba <- test_x %*% lba.model$A %*% t(lba.model$B) # predicted Y
## mean sqaure error
mse <- mean((test_y - y_pred.lba)^2) # mse = 0.11
mse

## accuracy + precision + recall + specificity + f1-score
# Confusion matrix result
colnames(y_pred.lba) <- row.names(lba.model$B) 
y_pred.lba <- as.numeric(apply(y_pred.lba, 1, function(x) {colnames(y_pred.lba)[which.max(x)]}))  # predicted class
cm <- confusionMatrix(as.factor(y_pred.lba), reference = as.factor(test$y)) # accuracy = 0.64
acc <- as.matrix(cm,what="overall")[1] # acc
var <- c("Pos Pred Value","Recall", "Specificity", "F1") # all indicators
cm <- as.matrix(cm, what = "classes")[var,] # extract used indicators
cm.sum <- data.frame(LBA = round(c(mse[1], acc, apply(cm, 1, mean)),2))
row.names(cm.sum) <- c("mean square error","accuracy", "precision", "recall", "specificity", "f1-score")
write.csv(cm.sum, "Output/tab5_2_summary_prediction_lba.csv") # table 5 (LBA part: summary of the performance)

# draw the confusion matrix
eval <- evaluate(
  data = data.frame(predict = as.character(y_pred.lba), true = as.character(test$y)),
  target_col = "true",
  prediction_cols = "predict",
  type = "multinomial"
)
png("Output/fig5b_confusion_matrix_lba.png") # figure 5b
plot_confusion_matrix(eval)
dev.off()
