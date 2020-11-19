library("reshape2")


download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","data.zip")
unzip("data.zip")

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# 1. 
dataSet <- rbind(XTrain,XTest)

# 2. 
MeanSt <- grep("mean()|std()", features[, 2]) 
dataSet <- dataSet[,MeanSt]

# 4. 
featuresNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(dataSet) <- featuresNames[MeanSt]

subject <- rbind(subjectTrain, subjectTest)
names(subject) <- 'subject'
activity <- rbind(yTrain, yTest)
names(activity) <- 'activity'

dataSet <- cbind(subject,activity, dataSet)

# 3. 
groupActivity <- factor(dataSet$activity)
levels(groupActivity) <- activityLabels[,2]
dataSet$activity <- groupActivity

# 5. 
baseData <- melt(dataSet,(id.vars=c("subject","activity")))
secondDataSet <- dcast(baseData, subject + activity ~ variable, mean)
names(secondDataSet)[-c(1:2)] <- paste("[mean of]" , names(secondDataSet)[-c(1:2)] )
write.table(secondDataSet, "tidyData.txt", sep = ",")