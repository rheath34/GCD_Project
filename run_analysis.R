################################################
### Getting and Cleaning Data Course Project ###
################################################


# NOTE: This scrip was created and tested on a windows machine. 

# Create a data folder in the current working directory. This folder will be used to store the extracted data files
if(!file.exists("data")){
        dir.create("data")
}

# Download project data set into .\data directory
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", ".\\data\\project_data.zip")

# Capture download date and write to text file
dateDownload <- date()
write(dateDownload, file = ".\\data\\date_download.txt")

# Unzip the file to the current working directory
# The unzip function extracts the zip file to a folder named UCI HAR Dataset in the .\data folder under the current working directory
unzip(".\\data\\project_data.zip", exdir = ".\\data")

# We will be using the following files identified by the README file in the zipped data set:

# 'features.txt': List of all features.

# 'activity_labels.txt': Links the class labels with their activity name.

# 'train/X_train.txt': Training set.

# 'train/y_train.txt': Training labels.

# 'test/X_test.txt': Test set.

# 'test/y_test.txt': Test labels.


# Load required libraries needed to create a tidy data set
library(plyr)
library(dplyr)

########################################################################################
### Project Item 1. Merge the training and the test sets to create one data set.     ###
### Project Item 4. Appropriately label the data set with descriptive variable names ### 
########################################################################################

# create data frames for the test set, test labels and the subject who performed the activity
x_test <- read.table(".\\data\\UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table(".\\data\\UCI HAR Dataset\\test\\y_test.txt")
subject_test <- read.table(".\\data\\UCI HAR Dataset\\test\\subject_test.txt")

# Create data frames for the training set, training labels and the subject who performed the activity
x_train <- read.table(".\\data\\UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table(".\\data\\UCI HAR Dataset\\train\\y_train.txt")
subject_train <- read.table(".\\data\\UCI HAR Dataset\\train\\subject_train.txt")

# Merge the training and test sets and training and test lables
x_merge <- rbind_list(x_train, x_test)
y_merge <- rbind_list(y_train, y_test)
subject_merge <- rbind_list(subject_train, subject_test)

# The features.txt file contains all the column headings for the 561 variables in the merged dataset (x_merge)
features <- read.table(".\\data\\UCI HAR Dataset\\features.txt")

# Using the features data frame, update the column headings in the x_merge data set
colnames(x_merge) <- as.vector(features[,2])

# Add the test labels to the x_merge data set
x_merge["test_labels"] <- y_merge

# Add the subject numbers to the x_merge data set
x_merge["subject_number"] <- subject_merge


#############################################################################################################
### Project Item 2. Extract only the measurements on the mean and standard deviation for each measurement ###
#############################################################################################################

x_measures <- select(x_merge, test_labels, subject_number, contains("mean()", ignore.case = TRUE), contains("std", ignore.case = TRUE))

#############################################################################################
### Project Item 3. Use descriptive activity names to name the activities in the data set ###
#############################################################################################

# The activity_labels.text file contains the descriptive activity labels that correspond to the test_lables 
activities <- read.table(".\\data\\UCI HAR Dataset\\activity_labels.txt")
colnames(activities) <- c("activity_number","activity_description")

x_activities <- inner_join(activities, x_measures, by = c("activity_number" = "test_labels"))

# Remove the activy_number column (now redundant) from the tidy set
x_activities <- select(x_activities, -activity_number)

####################################################################################################################################################
### Project Item 5.                                                                                                                              ###
### From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject ###
####################################################################################################################################################

# In order to create a tidy set, we must convert the measurement columns to a measurement type variable and create a row for each mesurement
tidy_tmp <- gather(x_activities, measurement_type, measurement, - activity_description, -subject_number)

tidy <- ddply(tidy_tmp, c("subject_number", "activity_description", "measurement_type"), summarise, average = mean(measurement))

################################################
### Write final tidy data set to a text file ###
################################################

write.table(tidy, ".\\tidydata.txt", row.name = FALSE)

