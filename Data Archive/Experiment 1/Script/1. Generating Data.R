rm(list=ls()) # clear all

###################################################################################
########### Example data 1 - one explanatory variable - Data generating mechanism
###################################################################################

set.seed(1) # seed
P <- floor(runif(1000,1,7)) # observed predictor P with 6 categories (equal probability)
U <- floor(runif(1000,1,4)) # unobserved predictor U with 3 categories (equal probability)

y <- 1 + 2 * P+ 0.2 * U + rnorm(1000) # \tilde{Y} = 1 + 2 * P + 0.2 * U + \epsilon

y <- as.numeric(cut(y,breaks = quantile(y, probs = seq(0,1, length.out = 5)) , include.lowest = T)) # categorize \tilde{Y} to 4 categories
data <- data.frame(P = P,
                   U = U,
                   y = y) # data

indices <- sample(1:1000, 200, replace = F) # indices for test set (200 obs)
train <- data[-indices,] # training set
test <- data[indices,] # test set

write.csv(data, "Data/data_1.csv", row.names = F) # save the whokl data 
write.csv(train,"Data/traindata_1.csv", row.names = F)  # save the training set
write.csv(test, "Data/testdata_1.csv",row.names = F) # save the test set


rm(list=ls())
