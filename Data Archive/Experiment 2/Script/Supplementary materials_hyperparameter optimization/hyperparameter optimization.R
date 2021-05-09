######################################################################################
############# hyperparameter tuning
######################################################################################

# Load packages and functions
library(tensorflow)
library(keras)

########## grid search function 
# hyperparameters include:
# 1. number of hidden neurons (units)
# 2. activation functions (cat1, cat2)
# 3. learning rate (lr)
run_tuning <- function(formula, data, 
                       interaction = F, 
                       directory = "hyperparameter tuning",
                       units = 2^seq(1,8),
                       cat1 = c("linear", "relu"),
                       cat2 = c("linear", "relu", "softmax"),
                       lr = c(0.01,0.001,0.0001),
                       sample = 1) {
  library(magrittr)
  aux.form <- strsplit(as.character(formula), split = "~") # extract the elements
  response.var <- aux.form[[2]] # response variables
  if (aux.form[3] == ".") {
    explanatory.var <- colnames(data)[-which(colnames(data) == response.var )] # explanatory variabls 
  } else {
    explanatory.var <- unlist(strsplit(aux.form[[3]], ' \\+ '))
  }
  # Response variable and make the output matrix
  num.cat.resp <- length(unique(data[[response.var]])) # number of the response variables
  name.cat.resp <- levels(as.factor(data[[response.var]])) # name of the response variables
  resp.matrix <- keras::to_categorical(as.numeric(as.factor(data[[response.var]]))-1, num.cat.resp) # output data matrix 
  colnames(resp.matrix) <- name.cat.resp
  # Explanatory variables and make the input matrix
  if (interaction == F) { 
    num.cat.exp <- NULL
    exp.matrix <- NULL
    name.cat.exp <- NULL
    for (i in 1:length(explanatory.var)) {
      num.cat.exp[i] <- length(unique(data[[explanatory.var[i]]]))
      exp.matrix <- cbind(exp.matrix, keras::to_categorical(as.numeric(as.factor(data[[explanatory.var[i]]]))-1, num.cat.exp[i]))
      name.cat.exp <- c(name.cat.exp, levels(as.factor(data[[explanatory.var[i]]])))
    }
    colnames(exp.matrix) <- name.cat.exp
  } else {
    interaction.var <- data[[explanatory.var[1]]]
    for (i in 2:length(explanatory.var)) {
      interaction.var <- paste0(interaction.var, "+", data[[explanatory.var[i]]])
    }
    #interaction.var <- paste0(interaction.var, data[[explanatory.var[-1]]])
    num.cat.exp <- length(unique(interaction.var))
    exp.matrix <- keras::to_categorical(as.numeric(as.factor(interaction.var))-1, num.cat.exp)
    name.cat.exp <- levels(as.factor(interaction.var))
    colnames(exp.matrix) <- name.cat.exp
  }
  # as follows are the hyperparameter lists: 
  par <- list(
    units = units,
    cat1 = cat1,
    cat2 = cat2,
    lr = lr)
  runs <- tfruns::tuning_run('Script/Supplementary materials_hyperparameter optimization/tuning setting.R', 
                             runs_dir = directory, sample = sample, flags = par) # run the tuning
  return(runs)
}

set_random_seed(5) # seed
runs <- run_tuning(Class ~ V1 + V2 + V3 + V4 + V5, data = train, 
                   directory = "Script/Supplementary materials_hyperparameter optimization", units = 2^seq(4,7))
# runs[which.max(runs$metric_val_accuracy),]
saveRDS(runs, "Script/Supplementary materials_hyperparameter optimization/example2.rds")