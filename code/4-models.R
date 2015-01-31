load("data/clean/MLBgames.rda")

# remove incomplete cases
MLBgames <- MLBgames[complete.cases(MLBgames),]

# remove irrelevant variables
MLBgames$Date <- NULL
MLBgames$Year <- NULL
MLBgames$Outcome <- NULL
MLBgames$State <- NULL
MLBgames$Stadium <- NULL
levels(MLBgames$DayNight)[1] <- NA

# split into test, train & validate
set.seed(42)
index <- sample(1:nrow(MLBgames), nrow(MLBgames)/5, replace=FALSE)
temp <- MLBgames[index,]
train <- MLBgames[-index,]
rm(index)
index <- sample(1:nrow(temp), nrow(temp)/10, replace=FALSE)
test <- temp[-index,]
validate <- temp[index,]
rm(MLBgames, index, temp)
save(train, file="data/clean/train.rda")
save(test, file="data/clean/test.rda")
save(validate, file="data/clean/validate.rda")
rm(test, validate)

# regression
library("caret")
lmControl <- trainControl(method="cv", number=10)
lmFit <- train(Attendance ~ ., data=train, method="lm", trControl=lmControl)
rm(lmControl)
save(lmFit, file="data/models/lmFit.rda")

# decision trees (rpart)
library("rpart")
dtreeFit <- rpart(Attendance ~ ., data=train, method="anova", control=rpart.control(cp=0.0001, xval=10))
save(dtreeFit, file="data/models/dtreeFit.rda")

# random forest
library("randomForest")
rfFit <- randomForest(Attendance ~ ., data=train)
save(rfFit, file="data/models/rfFit.rda")

# support vector machine

# gradient boosted machine