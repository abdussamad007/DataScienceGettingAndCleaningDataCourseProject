#################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Abdus Mondal Software Engineer
## 2017-04-20

# run_analysis.R File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# 1. Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5.From the data set in step 4, creates a second, independent tidy data set with the average 
# 6.of each variable for each activity and each subject.

##############################################################################################

#Section 1: Create the project folder

#Create the project folder

current_dir <- getwd()
sub_dir <-"dataCleaningPrj"
if(file.exists(sub_dir)){
  setwd(file.path(current_dir,sub_dir))
}else{
  dir.create(file.path(current_dir,sub_dir))
}

#Section 2:download the data and unzip

#download the files
file_name<-"sample_dataset.zip"
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
require(downloader)
download(file_url,file_name,mode = "wb")
if(!file.exists("UCI HAR Dataset")){
  unzip(file_name)
}

#List the files
#  dataPath <- file.path(".","UCI HAR Dataset")
 # files<-list.files(dataPath,recursive = TRUE)
  #files

#Section3: Read the file
#Read the data training data
  x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <-read.table("./UCI HAR Dataset/train/Y_train.txt")
  sub_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

  #Read the test data
  x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  
  #Read the feature
  features <- read.table('./UCI HAR Dataset/features.txt')
  #Read the activity level
  activity_labels = read.table('./UCI HAR Dataset/activity_labels.txt')
 
#Section4: create the dataset  
 #create X data.
  
  x_data <- rbind(x_train, x_test)  
  
#create Y data
  y_data <- rbind(y_train, y_test)
  
#create subject data
  subject_data <- rbind(sub_train, sub_test)
  
#Section 5: filter the dataset  
  # get only columns with mean() or std() in their names
  mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
  
  # subset the desired columns
  x_data <- x_data[, mean_and_std_features]
  
  names(x_data) <- features[mean_and_std_features, 2]
  
  y_data[, 1] <- activity_labels[y_data[, 1], 2]
  
  # correct column name
  names(y_data) <- "activity"
  
  
  # correct column name
  names(subject_data) <- "subject"
  
  # bind all the data in a single data set
  all_data <- cbind(x_data, y_data, subject_data)
 
  #Section 6: Get the result
   install.packages("plyr",dependencies = TRUE)
  library(plyr)
  averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
  
  write.table(averages_data, "./averages_data.txt", row.name=FALSE)
  