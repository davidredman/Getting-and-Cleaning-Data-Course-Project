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


    colnames(features) <- c("n", "functions") 
    colnames(x_train) <- features$functions
    colnames(y_train) <- "code"
    colnames(subj_train) <- "subject"
    colnames(x_test) <- features$functions
    colnames(y_test) <- "code"
    colnames(subj_test) <- "subject"
    colnames(activities) <- c("code", "activity")
    
    
# merge
    
    X  <-  rbind(x_train, x_test)
    Y  <-  rbind(y_train, y_test)
    subj_all  <-  rbind(subj_train, subj_test)
    Merged_Data <- cbind(subj_all,Y,X)
    
str(Merged_Data, max.level = 2, head=TRUE, list.len = 5)

  
# 2. extract measurements on mean/standard deviation for each measurement    
    
    colNames <- colnames(Merged_Data)
    
#return vector true or false, subset data and tidy

    
    measurements <-  (grepl("code", colNames) |
                          grepl("subject", colNames)|
                          grepl("mean..", colNames) |
                          grepl("std...", colNames) |
                          grepl("std...", colNames)
    )
    
    meanstddev <- Merged_Data[, measurements == TRUE]
    descactnames <- merge(meanstddev, activities,
                          #by ="activity",
                          all.x = TRUE) 
    
    
# 3. create tidy data and write the file to directory
    
    #tidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
    
    tidydata <- aggregate(.~subject + activity, descactnames, mean)
    tidydata <- tidydata[order(tidydata$subject, tidydata$activity), ]
    
    write.table(tidydata, file = "./tidy_data.txt", row.names = FALSE, col.names = TRUE)
    
