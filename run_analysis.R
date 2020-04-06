#load the dplyr library
library(dplyr)

# Downloaded data into Directory and read table data into R

setwd("C:/Users/chris/Desktop/w4proj")

# 1. read training & test data set & merge
    activities <- read.table("UCI HAR Dataset/activity_labels.txt")
    features <- read.table("./UCI HAR Dataset/features.txt")
    subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
    x_train  <- read.table("./UCI HAR Dataset/train/X_train.txt")
    y_train  <- read.table("./UCI HAR Dataset/train/y_train.txt")
    subj_train  <- read.table("./UCI HAR Dataset/train/subject_train.txt")
    x_test  <-  read.table("./UCI HAR Dataset/test/x_test.txt")
    y_test  <-  read.table("./UCI HAR Dataset/test/y_test.txt")
    subj_test  <-  read.table("./UCI HAR Dataset/test/subject_test.txt")

# name

    colnames(x_train) <- features[,2]
    colnames(y_train) <- "activityID"
    colnames(subj_train) <- "subjectID"
    colnames(x_test) <- features[,2]
    colnames(y_test) <- "activityID"
    colnames(subj_test) <- "subjectID"
    colnames(activities) <- c("activityID", "activityType") 
    
# merge
    
    X  <-  rbind(x_train, x_test)
    Y  <-  rbind(y_train, y_test)
    subj_all  <-  rbind(subj_train, subj_test)
    Merged_Data <- cbind(subj_all,Y,X)
    
str(Merged_Data, max.level = 2, head=TRUE, list.len = 5)

  
# 2. extract measurements on mean/standard deviation for each measurement    
    
    colNames <- colnames(Merged_Data)
    
#return vector true or false, subset data and tidy
    
    measurements <-  (grepl("activityID", colNames) |
                        grepl("subjectID", colNames) |
                          grepl("mean..", colNames) |
                          grepl("std...", colNames)
                      )
    
    meanstddev <- Merged_Data[, measurements == TRUE]
    descactnames <- merge(meanstddev, activities,
                          by ="activityID",
                          all.x = TRUE) 
    
    
# 3. create tidy data and write the file to directory
    
    tidydata <- aggregate(.~subjectID + activityID, descactnames, mean)
    tidydata <- tidydata[order(tidydata$subjectID, tidydata$activityID), ]
    
    write.table(tidydata, file = "./tidy_data.txt", row.names = FALSE, col.names = TRUE)
    
