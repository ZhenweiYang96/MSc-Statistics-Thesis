####### calculate the distance between each other
cal_dis <- function(data) {
  num_points <- ncol(data)
  name_points <- colnames(data)
  scenarios <- combn(name_points,2)
  dist <- NULL
  for (i in 1: 1:ncol(scenarios)) {
    dist[i] <- sqrt(sum((data[[scenarios[1,i]]] - data[[scenarios[2,i]]])^2))
  }
  dist_data <- cbind(as.data.frame(t(scenarios)),dist)
  colnames(dist_data) <- c("cate1", "cate2", "distance")
  return(dist_data)
}


####### yield explanatory variable matrix
evm.test <- function(formula, newdata, trainingset, interaction = F) {
  aux.form <- strsplit(as.character(formula), split = "~")
  response.var <- aux.form[[2]]
  if (aux.form[3] == ".") {
    explanatory.var <- colnames(newdata)[-which(colnames(newdata) == response.var )]
  } else {
    explanatory.var <- unlist(strsplit(aux.form[[3]], ' \\+ '))
  }
  
  # make a complete set
  large <- rbind(newdata[explanatory.var], trainingset[explanatory.var])
  
  # Explanatory variables and make the input matrix
  if (interaction == F) {
    num.cat.exp <- NULL
    exp.matrix <- NULL
    name.cat.exp <- NULL
    for (i in 1:length(explanatory.var)) {
      num.cat.exp[i] <- length(unique(trainingset[[explanatory.var[i]]]))
      exp.matrix <- cbind(exp.matrix, keras::to_categorical(as.numeric(as.factor(large[[explanatory.var[i]]]))-1, num.cat.exp[i]))
      name.cat.exp <- c(name.cat.exp, levels(as.factor(trainingset[[explanatory.var[i]]])))
    }
    colnames(exp.matrix) <- name.cat.exp
  } else {
    interaction.var <- large[[explanatory.var[1]]]
    for (i in 2:length(explanatory.var)) {
      interaction.var <- paste0(interaction.var, "+", large[[explanatory.var[i]]])
    }
    #interaction.var <- paste0(interaction.var, data[[explanatory.var[-1]]])
    num.cat.exp <- length(unique(interaction.var))
    exp.matrix <- keras::to_categorical(as.numeric(as.factor(interaction.var))-1, num.cat.exp)
    name.cat.exp <- levels(as.factor(interaction.var))
    colnames(exp.matrix) <- name.cat.exp
  }
  exp.matrix <- exp.matrix[1:nrow(newdata),]
  
  
  
  return(exp.matrix)
}

#formula <- education ~ native.country
#newdata <-  testset.adult
#trainingset <- training.adult

####### yield response variable matrix
rvm.test <- function(formula, newdata, trainingset) {
  aux.form <- strsplit(as.character(formula), split = "~")
  response.var <- aux.form[[2]]
  # make a complete set
  large <- rbind(newdata[response.var], trainingset[response.var])
  # Response variable and make the output matrix
  num.cat.resp <- length(unique(trainingset[[response.var]]))
  name.cat.resp <- levels(as.factor(trainingset[[response.var]]))
  resp.matrix <- keras::to_categorical(as.numeric(as.factor(large[[response.var]]))-1, num.cat.resp)
  colnames(resp.matrix) <- name.cat.resp
  
  resp.matrix <- resp.matrix[1:nrow(newdata),]
  
  return(resp.matrix)
}

###### 
# tuning hyperparameters
run_tuning <- function(formula, data, 
                       interaction = F, 
                       directory = "hyperparameter tunning",
                       units = 2^seq(1,8),
                       cat1 = c("linear", "relu"),
                       cat2 = c("linear", "relu", "softmax"),
                       lr = c(0.01,0.001,0.0001),
                       sample = 1) {
  library(magrittr)
  aux.form <- strsplit(as.character(formula), split = "~")
  response.var <- aux.form[[2]]
  if (aux.form[3] == ".") {
    explanatory.var <- colnames(data)[-which(colnames(data) == response.var )]
  } else {
    explanatory.var <- unlist(strsplit(aux.form[[3]], ' \\+ '))
  }
  # Response variable and make the output matrix
  num.cat.resp <- length(unique(data[[response.var]]))
  name.cat.resp <- levels(as.factor(data[[response.var]]))
  resp.matrix <- keras::to_categorical(as.numeric(as.factor(data[[response.var]]))-1, num.cat.resp)
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
  par <- list(
    units = units,
    cat1 = cat1,
    cat2 = cat2,
    lr = lr)
  runs <- tfruns::tuning_run('tuning setting.R', runs_dir = directory, sample = sample, flags = par)
  return(runs)
}

# k-means visualization
# PCbiplot <- function(PC, x="PC1", y="PC2", cluster) {
#   # PC being a prcomp object
#   data <- data.frame(obsnames=row.names(pc$x), pc$x,cluster = cluster)
#   plot <- ggplot(data, aes_string(x=x, y=y)) +
#     geom_point(aes( color= as.factor(sapply(1:length(cluster), function(x) {paste("Cluster", cluster[x])})) ), alpha = 0.8) + 
#     geom_text(hjust=-0.3, vjust=0, size = 3, aes(label=obsnames, 
#                                        color= as.factor(sapply(1:length(cluster), function(x) {paste("Cluster", cluster[x])}))) )+
#     scale_color_discrete(name = "Clusters", labels = sapply(1:max(cluster), function(x) {paste("Cluster", x)})) +
#     guides(color = guide_legend(title="Clusters") )
#     #scale_shape_manual(values=1:nlevels(as.factor(cluster)))
#   plot <- plot + geom_hline(aes(yintercept=0), size=.2) + geom_vline(aes(xintercept = 0), size=.2)
#   datapc <- data.frame(varnames=rownames(PC$rotation), PC$rotation)
#   mult <- min(
#     (max(data[,y]) - min(data[,y])/(max(datapc[,y])-min(datapc[,y]))),
#     (max(data[,x]) - min(data[,x])/(max(datapc[,x])-min(datapc[,x])))
#   )
#   datapc <- transform(datapc,
#                       v1 = .7 * mult * (get(x)),
#                       v2 = .7 * mult * (get(y))
#   )
#   plot <- plot + coord_equal() + geom_text(data=datapc, aes(x=v1, y=v2, label=varnames), size = 3, vjust=-0.8, alpha = 0.8, color = "black")#F90563
#   plot <- plot + geom_point(data = datapc, aes(x = v1, y = v2), alpha = 0.8, shape = 25, color = "black", fill = "black")
#   # plot <- plot + geom_segment(data=datapc, aes(x=0, y=0, xend=v1, yend=v2), arrow=arrow(length=unit(0.2,"cm")), alpha=0.75)
#   plot <- plot + theme_bw()
#   plot
# }

