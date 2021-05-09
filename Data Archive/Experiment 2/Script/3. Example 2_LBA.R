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
train <- read.csv("Data/traindata_2.csv") # training
test <- read.csv("Data/testdata_2.csv") # test
data <- read.csv("Data/data_2.csv")

test_x <- evm.test(Class ~ V1 + V2 + V3 + V4 + V5, 
                   newdata = test, trainingset = train) # input data matrix for the test set
test_y <- rvm.test(Class ~ V1 + V2 + V3 + V4 + V5,
                   newdata = test, trainingset = train) # output data matrix for the test set

### contingency table
contable <- rbind(table(V1 = data$V1, class = data$Class), 
               table(V2 = data$V2, class = data$Class),
               table(V3 = data$V3, class = data$Class),
               table(V4 = data$V4, class = data$Class),
               table(V5 = data$V5, class = data$Class))
write.csv(contable, "Output/tab6_contingency_table_example2.csv") # table 3: contingency table of the data

#################################### LBA
set.seed(1)
lba.model <- lba(Class~V1 + V2 + V3 + V4 + V5, data = train, K = 8, 
                 method = "ls", trace.lba = F) # build LBA with 3 latent budgets

#################################### qualitative evaluation
write.csv(round(lba.model$A, 2), "Output/tab7_1_mixing parameters A.csv")
write.csv(round(lba.model$B, 2), "Output/tab7_2_latent budgets B.csv")


#################################### quantitative evaluation
y_pred.lba <- test_x %*% lba.model$A %*% t(lba.model$B) # predicted Y
## mean sqaure error
mse <- mean((test_y - y_pred.lba)^2) # mse = 0.23
mse

## accuracy + precision + recall + specificity + f1-score
# Confusion matrix result
colnames(y_pred.lba) <- row.names(lba.model$B) 
y_pred.lba <- as.numeric(apply(y_pred.lba, 1, function(x) {colnames(y_pred.lba)[which.max(x)]}))  # predicted class
cm <- confusionMatrix(as.factor(y_pred.lba), reference = as.factor(test$Class)) # accuracy = 0.64
acc <- as.matrix(cm,what="overall")[1] # acc
var <- c("Pos Pred Value","Recall", "Specificity", "F1") # all indicators
cm <- as.matrix(cm, what = "classes")[var,] # extract used indicators
cm.sum <- data.frame(LBA = round(c(mse[1], acc, apply(cm, 1, mean)),2))
row.names(cm.sum) <- c("mean square error","accuracy", "precision", "recall", "specificity", "f1-score")
write.csv(cm.sum, "Output/tab8_2_summary_prediction_lba.csv") # table 8 (LBA part: summary of the performance)

# draw the confusion matrix
eval <- evaluate(
  data = data.frame(predict = as.character(y_pred.lba), true = as.character(test$Class)),
  target_col = "true",
  prediction_cols = "predict",
  type = "multinomial"
)
png("Output/fig8b_confusion_matrix_lba.png") # figure 8b
plot_confusion_matrix(eval)
dev.off()
