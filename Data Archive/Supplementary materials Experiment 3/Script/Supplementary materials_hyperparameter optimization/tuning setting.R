######################################################################################
############# Hyperparameter setting
######################################################################################

# Here are all the  hyperparameters and the inital values
FLAGS <- flags(
  flag_integer('units', 2),
  flag_string('cat1', "linear"),
  flag_string('cat2', "linear"),
  flag_numeric('lr', 0.01)
)

# build LBA-NN
build_model = function(hp) {
  input.layer <- keras::layer_input(shape=c(sum(num.cat.exp)))
  layers <- input.layer %>% 
    keras::layer_dense(units = FLAGS$units, 
                       activation = FLAGS$cat1) %>% 
    keras::layer_dense(units = length(name.cat.resp), activation = FLAGS$cat2)
  # define the neural network model
  lba.nn.model <- keras::keras_model(inputs = input.layer, outputs = layers)
  lba.nn.model %>% keras::compile(
    keras::optimizer_rmsprop(lr = FLAGS$lr),
    loss = "mse",
    metrics = list("accuracy")
  )
  return(lba.nn.model)
}
model <- build_model()
early_stop <- callback_early_stopping(monitor = "val_acc") # we will choose the model based on the accuracy on the test set

# fit the model
model %>% fit(
  exp.matrix,
  resp.matrix,
  epochs = 50,
  validation_data= list(test_x, test_y),
  verbose = 1,
  callbacks = list(early_stop)
)

