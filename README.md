Getting and Cleaning Data Course Project

What is in this README?
I. Purpose
II. Data Set Information
III. Course Project Goal
IV. Cookbook
V. Description of how run_analysis.R works

I.
The purpose of this project is to demonstrate our ability to collect, 
work with, and clean a data set. The goal is to prepare tidy data that
can be used for later analysis.

II.
Data Set Information:
The data for the project was a zip file containing both a test and training set of data. The test set contained 2947
observations while the training set contained 7352 observations. 

There was an activities label file indicating both the id and the description of the activities performed:
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

There was a features file included representing the 561 measurements captured for each observation.

III.
Course Project Goal:
The goal of the project was to create a tidy data set with the average of each variable for each activity
and each subject. The project limited the variables to only those pertaining to the mean and standard deviation
of each measurement.

IV.
Codebook:
subject_number: An integer in the range of 1-30 representing the volunteer performing the six activities.

activity_description: A factor representing one of six potential activities performed by the volunteer
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

measurement_type: The measurements recorded in the 561 columns of data were first filtered to only measurements
where a mean or standard deviation was recorded. This reduced the number of columns to 66 variables. These 66
variables were then transformed into a factor of 66 levels.

average: The average for each variable(measurement_type), for each activity_description, and each subject_number
was computed as a numeric value.
 
V.
run_analysis.R 

The script is broken into six sections. 

The first section creates a working data folder, downloads the data file
and unzips the file into the data folder. There are comments explaining what files I used
along with code to load two libraries used to create the tidy set.

The second section creates data frames to load the test and training sets along with the subject data. 
The training and test sets are merged along with the subjects and column headings are added.

The third section filters the 561 variables down to the 66 required for the project. The columns were selected based
on the column headings containing mean() and std.

The forth section adds the activity descriptions to the merged data set.

The fifth section creates the tidy data set by converting the measurement columns to a factor 
and creating a row for each measurement. There were 66 mean and std measurements, 30 volunteers and 6 activities.
This means the final tidy data set should contain 66 * 30 * 6 = 11,880 observations. This can be confirmed in the 
tidy data set I uploaded.

The final step writes the tidy data set to a text file needed for this project.
