######################################################################
########### dataset 1 in "constrained latent budget analysis 
######################################################################
rm(list=ls()) # clear all 
library(tidyverse) # load packages

# Note in this file we will convert values in a contingency table
# to a long format

######################################################################
# the function is used to convert the frequencies in the table to 
# cases in rows
countsToCases <- function(x, countcol = "Freq") {
  # Get the row indices to pull from x
  idx <- rep.int(seq_len(nrow(x)), x[[countcol]])
  
  # Drop count column
  x[[countcol]] <- NULL
  
  # Get the rows from x
  x[idx, ]
}
######################################################################
########  male data
table.male <- data.frame(
  row.names = c("10-15", "15-20", "20-25", "25-30", "30-35",
               "35-40", "40-45", "45-50", "50-55", "55-60",
               "60-65", "65-70", "70-75", "75-80", "80-85",
               "85-90", "90+"),
  asolliq = c(4, 348, 808, 789, 916, 1118,
             926, 855, 684, 502, 516, 513,
             425, 266, 159, 70, 18),
  bgas = c(0, 7, 32, 26, 17, 27,
             13, 9, 14, 6, 5, 8, 
             5, 4, 2, 1, 0),
  cothergas = c(0, 67, 229, 243, 257, 313,
               250, 203, 136, 77, 74, 31,
               21, 9, 2, 0, 1),
  dhss = c(247, 578, 699, 648, 825, 1278,
          1273, 1381, 1282, 972, 1249, 1360,
          1268, 866, 479, 259, 76),
  edrown = c(1, 22, 44, 52, 74, 87,
            89, 71, 87, 49, 83, 75,
            90, 63, 39, 16, 4),
  fgunexp = c(17, 179, 316, 268, 291, 293,
             299, 347, 229, 151, 162, 164,
             121, 78, 18, 10, 2),
  gknives = c(1, 11, 35, 38, 52, 49,
             53, 68, 62, 46, 52, 56,
             44, 30, 18, 9 ,4),
  hjump = c(6, 74, 109, 109, 123, 134,
           78, 103, 63, 66, 92, 115,
           119, 79, 46, 18, 6),
  iother = c(9, 175, 289, 226, 281, 268, 
            198, 190, 146, 77, 122, 95,
            82, 34, 19, 10, 2)
)

data.male <- table.male %>%
  rownames_to_column() %>%            # set row names as a variable
  gather(rowname2,Freq,-rowname)

data.male <- countsToCases(data.male)

data.male$gender <- rep("male", nrow(data.male)) # add indicator: gender

########  female data
table.female <- data.frame(
  row.names = c("10-15", "15-20", "20-25", "25-30", "30-35",
                "35-40", "40-45", "45-50", "50-55", "55-60",
                "60-65", "65-70", "70-75", "75-80", "80-85",
                "85-90", "90+"),
  asolliq = c(28, 353, 540, 454, 530, 688,
              566, 716, 942, 723, 820, 740,
              624, 495, 292, 113, 24),
  bgas = c(0, 2, 4, 6, 2, 5,
           4, 6, 7, 3, 8, 8,
           6, 8, 3, 4, 1),
  cothergas = c(3, 11, 20, 27, 29, 44,
                24, 24, 26, 14, 8, 4,
                4, 1, 2, 0, 0),
  dhss = c(20, 81, 111, 125, 178, 272,
           343, 447, 691, 527, 702, 785,
           610, 420, 223, 83, 19),
  edrown = c(0, 6, 24, 33, 42, 64, 
             76, 94, 184, 163, 245, 271,
             244, 161, 78, 14, 4),
  fgunexp = c(1, 15, 9, 26, 14, 24,
              18, 13, 21, 14, 11, 4,
              1, 2, 0, 0, 0),
  gknives = c(0, 2, 9, 7, 20, 14,
              22, 21, 37, 30, 35, 38,
              27, 29, 10, 6, 2),
  hjump = c(10, 43, 78, 86, 92, 98,
            103, 95, 129, 92, 140, 156,
            129, 129, 84, 34, 7),
  iother = c(6, 47, 67, 75, 78, 110,
             86, 88, 131, 92, 114, 90, 
             46, 35, 23, 2, 0)
)

data.female <- table.female %>%
  rownames_to_column() %>%            # set row names as a variable
  gather(rowname2,Freq,-rowname)

data.female <- countsToCases(data.female)

data.female$gender <- rep("female", nrow(data.female)) # add indicator: gender

########## full data
data <- rbind(data.male, data.female)
colnames(data) <- c("age", "cause.of.death", "gender")
data <- data %>% dplyr::select(gender, age, cause.of.death)
write_csv(data, "Data/data_3.csv")

######### split the data
set.seed(123)
indices <- sample(1:nrow(data), 10000, replace = F) # indices for test data (10000 obs)
train <- data[-indices, ] # trtaining set
test <- data[indices,] # test set

write.csv(train,"Data/traindata_3.csv", row.names = F) # training set
write.csv(test, "Data/testdata_3.csv", row.names = F) # test set
