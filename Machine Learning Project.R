# Loading required libraries
library("caret")
library("rattle")
# Acess to the data

if(!file.exists("pml-training.csv")){download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv", destfile = "pml-training.csv")}
if(!file.exists("pml-testing.csv")){download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv", destfile = "pml-testing.csv")}

# Read the training data and enter NA to replace empty values/ remove columns with missing value

trainingDataSet<- read.csv("pml-training.csv", sep=",", header=TRUE, na.strings = c("NA","",'#DIV/0!'))
testingDataSet<- read.csv("pml-testing.csv", sep=",", header=TRUE, na.strings = c("NA","",'#DIV/0!'))
dim(trainingDataSet)
dim(testingDataSet)
trainingDataSet <- trainingDataSet[,(colSums(is.na(trainingDataSet)) == 0)]
dim(trainingDataSet)
testingDataSet <- testingDataSet[,(colSums(is.na(testingDataSet)) == 0)]
dim(testingDataSet)

# Data processing 

numericalsIdx <- which(lapply(trainingDataSet, class) %in% "numeric")
preprocessModel <-preProcess(trainingDataSet[,numericalsIdx],method=c('knnImpute', 'center', 'scale'))
pre_trainingDataSet <- predict(preprocessModel, trainingDataSet[,numericalsIdx])
pre_trainingDataSet$classe <- trainingDataSet$classe
pre_testingDataSet <-predict(preprocessModel,testingDataSet[,numericalsIdx])
nzv <- nearZeroVar(pre_trainingDataSet,saveMetrics=TRUE)
pre_trainingDataSet <- pre_trainingDataSet[,nzv$nzv==FALSE]
nzv <- nearZeroVar(pre_testingDataSet,saveMetrics=TRUE)
pre_testingDataSet <- pre_testingDataSet[,nzv$nzv==FALSE]

# Validation set and Train model

set.seed(12031987)
idxTrain<- createDataPartition(pre_trainingDataSet$classe, p=3/4, list=FALSE)
training<- pre_trainingDataSet[idxTrain, ]
validation <- pre_trainingDataSet[-idxTrain, ]
dim(training) ; dim(validation)
library(randomForest)
modFitrf <- train(classe ~., method="rf", data=training, trControl=trainControl(method='cv'), number=5, allowParallel=TRUE, importance=TRUE )
modFitrf

# Cross Validation Testing

predValidRF <- predict(modFitrf, validation)
confus <- confusionMatrix(validation$classe, predValidRF)
confus$table
accur <- postResample(validation$classe, predValidRF)
modAccuracy <- accur[[1]]
modAccuracy
out_of_sample_error <- 1 - modAccuracy

# Decision tree

set.seed(12345)
modFitA1 <- rpart(classe ~ ., data=myTraining, method="class")
fancyRpartPlot(modFitA1)
predictionsA1 <- predict(modFitA1, myTesting, type = "class")
cmtree <- confusionMatrix(predictionsA1, myTesting$classe)
cmtree
plot(cmtree$table, col = cmtree$byClass, main = paste("Decision Tree Confusion Matrix: Accuracy =", round(cmtree$overall['Accuracy'], 4)))

# Random forest

set.seed(12345)
modFitB1 <- randomForest(classe ~ ., data=myTraining)
predictionB1 <- predict(modFitB1, myTesting, type = "class")
cmrf <- confusionMatrix(predictionB1, myTesting$classe)
cmrf
plot(cmrf$table, col = cmtree$byClass, main = paste("Random Forest Confusion Matrix: Accuracy =", round(cmrf$overall['Accuracy'], 4)))

# Generalized boosted regression (GBR)

set.seed(12345)
fitControl <- trainControl(method = "repeatedcv",
                           number = 5,
                           repeats = 1)

gbmFit1 <- train(classe ~ ., data=myTraining, method = "gbm",
                 trControl = fitControl,
                 verbose = FALSE)


gbmFinMod1 <- gbmFit1$finalModel

gbmPredTest <- predict(gbmFit1, newdata=myTesting)
gbmAccuracyTest <- confusionMatrix(gbmPredTest, myTesting$classe)
gbmAccuracyTest
plot(gbmFit1, ylim=c(0.9, 1))

# applying the most accurate algorithm (RF)

FinalTestPred <- predict(model_RF,newdata=validation)
FinalTestPred
