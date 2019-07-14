orange_juice<-read_csv("https://raw.githubusercontent.com/selva86/datasets/master/orange_juice_withmissing.csv")


orange_juice %>% glimpse

# check for NA
orange_juice %>% 
  summarize_all(.funs = ~sum(is.na(.)))

orange_juice %>% str

# Create the training and test datasets
set.seed(100)

# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(orange_juice$Purchase, p=0.8, list=FALSE)

# Step 2: Create the training  dataset
trainData <- orange_juice[trainRowNumbers,]

# Step 3: Create the test dataset
testData <- orange_juice[-trainRowNumbers,]

# Store X and Y for later use.
X<-trainData %>% 
  select(-Purchase)

Y<- trainData$Purchase

# testData_clean %>% 
#   summarize_all(~sum(is.na(.))) %>% View

# Impute missing values in test data
# Impute missing values
# Create the knn imputation model on the training data
preProcess_missingdata_model_test <- preProcess(testData, method='medianImpute')
preProcess_missingdata_model_test

# Use the imputation model to predict the values of missing data points
testData_clean <- predict(preProcess_missingdata_model_test, newdata = testData)


# Impute missing values
# Create the knn imputation model on the training data
preProcess_missingdata_model <- preProcess(trainData, method='medianImpute')
preProcess_missingdata_model

# Use the imputation model to predict the values of missing data points
trainData_clean <- predict(preProcess_missingdata_model, newdata = trainData)

# check for NA
trainData_clean %>% 
  summarise_all(.funs = ~sum(is.na(.))) %>% View()

# One hot encoding of factors
# Creating dummy variables is converting a categorical variable to as many binary variables as here are categories.
dummies_model <- dummyVars(Purchase ~ ., data=trainData)

# Create the dummy variables using predict. The Y variable (Purchase) will not be present in trainData_mat.
trainData_mat <- predict(dummies_model, newdata = trainData)

# # Convert to dataframe
trainData <- data.frame(trainData_mat)
trainData %>% glimpse
# # See the structure of the new dataset
str(trainData)

# Transform the data
# 1. range: Normalize values so it ranges between 0 and 1
# 2. center: Subtract Mean
# 3. scale: Divide by standard deviation
# 4. BoxCox: Remove skewness leading to normality. Values must be > 0
# 5. YeoJohnson: Like BoxCox, but works for negative values.
# 6. expoTrans: Exponential transformation, works for negative values.
# 7. pca: Replace with principal components
# 8. ica: Replace with independent components
# 9. spatialSign: Project the data to a unit circle

names(getModelInfo())

preProcess_range_model <- preProcess(trainData, method='range')
trainData <- predict(preProcess_range_model, newdata = trainData)

summary(trainData)

# Set the seed for reproducibility
set.seed(100)

# Train the model using randomForest and predict on the training data itself.
model_rf = train(as.factor(Purchase) ~ ., data=trainData_clean, method='ranger')
predicted <- predict(model_rf,testData_clean)

# save model
saveRDS(model_rf, "model_rf.rds")


# confusion matrix
# Compute the confusion matrix
confusionMatrix(predicted,as.factor(testData_clean$Purchase))

# cross validations
default_knn_mod<-train(
  Purchase ~ .,
  data = trainData_clean,
  method = "knn",
  trControl = trainControl(method = "repeatedcv", number = 5,repeats = 10),
  preProcess = c("center", "scale"),
  tuneGrid = expand.grid(k = seq(1, 101, by = 2))
)

plot(default_knn_mod)
default_knn_mod$bestTune

# make predictions
predictKNN<-predict(default_knn_mod,trainData_clean)

# Calculate accuracy
confusionMatrix(predictKNN,as.factor(trainData_clean$Purchase))
