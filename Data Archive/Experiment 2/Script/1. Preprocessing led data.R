rm(list=ls()) # clear all

###################################################################################
########### Example data 2 - five explanatory variable
###################################################################################
# load package
library(tidyverse)

#### row data can be downloaded from https://www.openml.org/d/40496
#### or https://archive.ics.uci.edu/ml/datasets/LED+Display+Domain
#### the data includes 7 features but we just keep the first 5

led <- read.csv("Data/phpSj3fWL.csv") # raw data 

# recode the 5 features from 1/0 to Vi-1/Vi-0 (i /in {1,...,5})
for (i in 1:5) {
  led[,i] <- recode(led[,i], `1` = paste0(colnames(led)[i], "-1"), `0` = paste0(colnames(led)[i], "-0"))
}

# split the data
set.seed(24) # seed
indice <- sample(1:nrow(led), 0.8 * nrow(led), replace = F) # indices for test data (20% obs)
training <- led[indice,] # training set
test <- led[-indice,] # test set

write_csv(training, "Data/traindata_2.csv") # training set
write_csv(test, "Data/testdata_2.csv") # test set
write_csv(led, "Data/data_2.csv") # the whole data (recoded)

rm(list=ls())


