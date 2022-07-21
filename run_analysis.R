
# The goal is to prepare tidy data that can be used for later analysis. 

library(dplyr)


# downloading and unzipping the data

url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "getdata_projectfiles_UCI HAR Dataset.zip"

if (!file.exists(zipfile)) {
    download.file(url, zipfile, method="curl")
}

if (!file.exists("UCI HAR Dataset")) { 
    unzip(zipfile) 
}


# reading the datasets into R


features <- read.table("UCI HAR Dataset/features.txt", row.names=1)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                              col.names = c("label", "activity"))

train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "label")

test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "label")

names(train_set) <- features[,1]
names(test_set) <- features[,1]


# 1. Merges the training and the test sets to create one data set.


set <- rbind(train_set, test_set)
labels <- rbind(train_labels, test_labels)
subject <- rbind(train_subject, test_subject)
merged_train_test <- cbind(subject, set, labels)


# 2. Extracts only the measurements on the mean and standard deviation for each 
# measurement. 


extracted_data <- select(merged_train_test,
                         subject, label, 
                         grep("mean|std", names(merged_train_test), 
                               ignore.case = TRUE))
 

# 3. Uses descriptive activity names to name the activities in the data set


extracted_data <- mutate(extracted_data, 
                         label=activity_labels[extracted_data$label, 2])


# 4. Appropriately labels the data set with descriptive variable names. 


names(extracted_data) <- gsub("^t", "TimeDomain", names(extracted_data))
names(extracted_data) <- gsub("Acc", "Accelerometer", names(extracted_data))
names(extracted_data) <- gsub("-mean", "Mean", names(extracted_data), ignore.case = TRUE)
names(extracted_data) <- gsub("-std", "STD", names(extracted_data), ignore.case = TRUE)
names(extracted_data) <- gsub("gravity", "Gravity", names(extracted_data))
names(extracted_data) <- gsub("Gyro", "Gyroscope", names(extracted_data))
names(extracted_data) <- gsub("Mag", "Magnitude", names(extracted_data))
names(extracted_data) <- gsub("^f", "FrequencyDomain", names(extracted_data))
names(extracted_data) <- gsub("tBody", "TimeDomainBody", names(extracted_data))
names(extracted_data) <- gsub("-freq", "Frequency", names(extracted_data), ignore.case = TRUE)
names(extracted_data) <- gsub("freq", "Frequency", names(extracted_data), ignore.case = TRUE)
names(extracted_data) <- gsub("angle", "Angle", names(extracted_data))
names(extracted_data) <- gsub("BodyBody", "Body", names(extracted_data))
names(extracted_data)[2] <- "Activity"
names(extracted_data) <-gsub("\\(\\)", "", names(extracted_data))


# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.


RequiredData <- extracted_data %>%
    group_by(subject, Activity) %>%
    summarise_all(list(mean))


# printing the data into the console:
RequiredData


# exporting the data
write.table(RequiredData, "RequiredData.txt", row.name=FALSE)
