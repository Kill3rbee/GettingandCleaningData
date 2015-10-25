#Required libraries
library(data.table)
library(dplyr)

# Local data zip file
dataFileZIP <- "./Dataset.zip"

# Name of unzipped Directory
dirFile <- "UCI HAR Dataset"

# Download the dataset (. ZIP), if it does not exist
if (file.exists(dataFileZIP) == FALSE) {
  # Sometimes changing https to http and skip method="curl" 
  # in the download.file works if having problems with curl
  fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "Dataset.zip")
}

# Uncompress data file if non exists
if (file.exists(dirFile) == FALSE) {
   unzip("./Dataset.zip")
}

#Read Supporting Metadata
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Read subject, activity and features training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

#Read subject, activity and features test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)


#Part 1 - Merge the training and the test sets to create one data set
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#Change column names in features using variables names from featureNames
colnames(features) <- t(featureNames[2])

#Change column names for activity and subject data frames
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
#Combine sequence of data frames into new complete data frame by columns
completeData <- cbind(features,activity,subject)


#Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

#Adding activity and subject columns
requiredColumns <- c(columnsWithMeanSTD, 562, 563)

#Extract required columns into new dataset
extractedData <- completeData[,requiredColumns]

#Part 3 - Uses descriptive activity names to name the activities in the data set
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
#SChange activity variable column from int to factor
extractedData$Activity <- as.factor(extractedData$Activity)


#Part 4 - Appropriately labels the data set with descriptive variable names. 

#Acc is replaced with Accelerometer
#Gyro is replaced with Gyroscope
#BodyBody is replaced with Body
#Mag is replaced with Magnitude
#Character 'f' is replaced with Frequency
#Character 't' is replaced with Time

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))


#Glimpse of new variable names
names(extractedData)[1:4]

#Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Change subject variable column from int to factor
extractedData$Subject <- as.factor(extractedData$Subject)
#Create dataframe
extractedData <- data.table(extractedData)

#Create tidyData as a set with average for each activity and subject
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)

#Order tidayData according to subject and activity
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]

#Write tidyData into a text file
#write.table(tidyData, file = "Tidy.txt", row.names = FALSE)

# write the tidy data set to a file
write.csv(tidyData, "tidy.csv", row.names=FALSE)
