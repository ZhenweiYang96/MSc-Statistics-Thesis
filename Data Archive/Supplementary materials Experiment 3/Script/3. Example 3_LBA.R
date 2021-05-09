######################################################################################
############# LBA Implementation on Example 3
######################################################################################
rm(list=ls())

# Load packages and functions
source("Script/4. function.R")
library(lba)
library(tidyverse)
library(caret)
library(cvms)

######################################################################################
############# Previous data in "constrained LBA"
######################################################################################
# load data
train <- read.csv("Data/traindata_3.csv") # training
test <- read.csv("Data/testdata_3.csv") # test
data <- read.csv("Data/data_3.csv")

test_x <- evm.test(cause.of.death ~ gender + age, 
                   newdata = test, trainingset = train) # input data matrix for the test set
test_y <- rvm.test(cause.of.death ~ gender + age,
                   newdata = test, trainingset = train) # output data matrix for the test set

### contingency table
contable <- rbind(table(data %>% filter(gender == "male") %>% dplyr::select(-gender)),
              table(data %>% filter(gender == "female") %>% dplyr::select(-gender)))
contable <- addmargins(contable)

write.csv(contable, "Output/tabS2_contingency_table_example3.csv") # table 3: contingency table of the data

#################################### LBA
set.seed(1)
lba.model <- lba(cause.of.death ~ gender + age, data = train, K = 3, 
                 method = "ls", trace.lba = F) # build LBA with 3 latent budgets

#################################### qualitative evaluation
write.csv(round(lba.model$A, 2), "Output/tabS3_1_mixing parameters A.csv")
write.csv(round(lba.model$B, 2), "Output/tabS3_2_latent budgets B.csv")


#################################### quantitative evaluation
y_pred.lba <- test_x %*% lba.model$A %*% t(lba.model$B) # predicted Y
## mean sqaure error
mse <- mean((test_y - y_pred.lba)^2) # mse = 0.11
mse

## accuracy + precision + recall + specificity + f1-score
# Confusion matrix result
colnames(y_pred.lba) <- row.names(lba.model$B)
y_pred.lba <- apply(y_pred.lba, 1, function(x) {colnames(y_pred.lba)[which.max(x)]})  # predicted class
cm <- confusionMatrix(as.factor(y_pred.lba), reference = as.factor(test$cause.of.death)) # accuracy = 0.43
acc <- as.matrix(cm,what="overall")[1] # acc
var <- c("Pos Pred Value","Recall", "Specificity", "F1") # all indicators
cm <- as.matrix(cm, what = "classes")[var,] # extract used indicators
cm.sum <- data.frame(LBA = round(c(mse[1], acc, apply(cm, 1, mean)),2))
row.names(cm.sum) <- c("mean square error","accuracy", "precision", "recall", "specificity", "f1-score")
write.csv(cm.sum, "Output/tabS4_2_summary_prediction_lba.csv") # table S4 (LBA part: summary of the performance)

# draw the confusion matrix
eval <- cvms::evaluate(
  data = data.frame(predict = as.character(y_pred.lba), true = as.character(test$cause.of.death)),
  target_col = "true",
  prediction_cols = "predict",
  type = "multinomial"
)
png("Output/figS3b_confusion_matrix_lba.png") # figure S3b
plot_confusion_matrix(eval)
dev.off()
