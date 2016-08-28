library(reshape2)
filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename)
} 

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
} 

# Loading  activity labels and the  features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])


# Code to extract only the mean and standard deviation details
featuresDesired <- grep(".*mean.*|.*std.*", features[,2])
featuresDesired.names <- features[featuresDesired,2]
featuresDesired.names = gsub('-mean', 'Mean', featuresDesired.names)
featuresDesired.names = gsub('-std', 'Std', featuresDesired.names)
featuresDesired.names <- gsub('[-()]', '', featuresDesired.names)


# Loading the train dataset anlong with Activities and Subjects.
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresDesired]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Loading the test dataset anlong with Activities and Subjects.
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresDesired]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge train and test dataset.
entire_data_set <- rbind(train, test)
colnames(entire_data_set) <- c("subject", "activity", featuresDesired.names)

entire_data_set.melted <- melt(entire_data_set, id = c("subject", "activity"))
entire_data_set.mean <- dcast(entire_data_set.melted, subject + activity ~ variable, mean)
write.table(entire_data_set.mean, "tidy.txt", row.names = FALSE, quote = FALSE)









