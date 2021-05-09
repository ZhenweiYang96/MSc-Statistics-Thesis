######################################################################################
############# All involved functions 
######################################################################################

####### generate the input data matrix
# this function has the arguments:
# 1. formula: 
# 2. newdata: the name of the test set
# 3. trainingset: the name of the training set
# 4. interaction: make the interacted categories, e.g., Amercian - male, Amercian - female,
# note that if we want to generate the matrix for training set, the newdata should also be 
# training set
evm.test <- function(formula, newdata, trainingset, interaction = F) {
  # extract the elements in the formula
  aux.form <- strsplit(as.character(formula), split = "~")
  response.var <- aux.form[[2]] # response categories
  if (aux.form[3] == ".") { # "." means all the variables except response.var considered as explanatory variables
    explanatory.var <- colnames(newdata)[-which(colnames(newdata) == response.var )] 
  } else {
    explanatory.var <- unlist(strsplit(aux.form[[3]], ' \\+ ')) # extract the listed explanatory variables 
  }
  
  # make a complete set
  large <- rbind(newdata[explanatory.var], trainingset[explanatory.var]) 
  
  # Explanatory variables and make the input matrix
  if (interaction == F) { 
    num.cat.exp <- NULL # the number of the explanatory categories
    exp.matrix <- NULL # input data matrix
    name.cat.exp <- NULL # the name of the explanatory categories
    for (i in 1:length(explanatory.var)) { 
      num.cat.exp[i] <- length(unique(trainingset[[explanatory.var[i]]]))
      exp.matrix <- cbind(exp.matrix, keras::to_categorical(as.numeric(as.factor(large[[explanatory.var[i]]]))-1, num.cat.exp[i]))
      name.cat.exp <- c(name.cat.exp, levels(as.factor(trainingset[[explanatory.var[i]]])))
    }
    colnames(exp.matrix) <- name.cat.exp
  } else { # here we will recode the interacted categoris as "A + B"
    interaction.var <- large[[explanatory.var[1]]] 
    for (i in 2:length(explanatory.var)) {
      interaction.var <- paste0(interaction.var, "+", large[[explanatory.var[i]]])
    }
    num.cat.exp <- length(unique(interaction.var))
    exp.matrix <- keras::to_categorical(as.numeric(as.factor(interaction.var))-1, num.cat.exp)
    name.cat.exp <- levels(as.factor(interaction.var))
    colnames(exp.matrix) <- name.cat.exp
  }
  exp.matrix <- exp.matrix[1:nrow(newdata),]  # obs in the newdata matrix
  
  return(exp.matrix) # output the input data matrix: exp.matrix 
}

####### generate output data matrix
# this function has the arguments:
# 1. formula: 
# 2. newdata: the name of the test set
# 3. trainingset: the name of the training set
# note that if we want to generate the matrix for training set, the newdata should also be 
# training set
rvm.test <- function(formula, newdata, trainingset) {
  aux.form <- strsplit(as.character(formula), split = "~") # extract the elements in the formula
  response.var <- aux.form[[2]] 
  # make a complete set
  large <- rbind(newdata[response.var], trainingset[response.var])
  # Response variable and make the output matrix
  num.cat.resp <- length(unique(trainingset[[response.var]])) # the number of the response categories
  name.cat.resp <- levels(as.factor(trainingset[[response.var]])) # the name of the response categories
  resp.matrix <- keras::to_categorical(as.numeric(as.factor(large[[response.var]]))-1, num.cat.resp) # output data matrix
  colnames(resp.matrix) <- name.cat.resp
  
  resp.matrix <- resp.matrix[1:nrow(newdata),] # obs in the newdata matrix
  
  return(resp.matrix) # output the output data matrix: resp.matrix 
}

