path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists('UCI HAR Dataset')) {
  download.file(url, file.path(path, "data.zip"))
  unzip(zipfile = "data.zip")
}

features <- read.csv('./UCI HAR DATASET/features.txt', header = F, sep = " ")
activities <- read.csv('./UCI HAR DATASET/activity_labels.txt', header = F, sep = " ")

impFeaturesRows <- grep('(mean|std)\\(\\)', features[, 2])
impFeatures <- features[impFeaturesRows,2]

library(gsubfn)

impFeatures <- gsubfn("(^t|^f|Acc|Gyro|Mag|BodyBody|\\(\\))",
                    list(
                      "t" = "Time",
                      "f" = "Frequency",
                      "Acc" = "Accelerometer",
                      "Gyro" = "Gyroscope",
                      "Mag" = "Magnitude",
                      "BodyBody" = "Body",
                      "()" = ""), 
                      impFeatures)

train <- read.table("UCI HAR Dataset/train/X_train.txt")[impFeaturesRows]
trainActivity <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = Activity)
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = Subject)
train <- cbind(trainSubject, trainActivity, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[impFeaturesRows]
testActivity <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubject, testActivity, test)

TrainTestData <- rbind(train, test) 
colnames(TrainTestData) <- c("subject", "activity", impFeatures)

TrainTestData$activity <- factor(TrainTestData$activity, levels = activities[,1], labels = activities[,2])
TrainTestData$subject <- as.factor(TrainTestData$subject)

TrainTestData <- as.data.table(TrainTestData)

meltData <- melt(TrainTestData, id = c("subject", "activity"))
meanData <- dcast(meltData, subject + activity ~ variable, mean)

write.table(meanData, "tidy_data.txt", row.names = FALSE, quote = FALSE)
