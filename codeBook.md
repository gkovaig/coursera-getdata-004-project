# Project work for Johns Hopkins School of Public Health / Coursera
# Getting and Cleaning Data - https://class.coursera.org/getdata-004/
Submitted by Raj Manickam on 2014-06-10
Project is to demonstrate ability to collect, work with, and clean a data set.  Based on data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

Start with Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

Please refer to source for details on coding and preparation of source data.

# Merge the training and the test sets to create one data set
Source data in two separate sets (called 'train' and 'test').  Data on corresponding 'subject' and 'activity' are found in separate files.  These are combined into one dataset ('har.all').

A high-level test for missing values did not find any value missing in any column of any observation.

# Use descriptive activity names to name the activities in the data set
Activity is coded as numeric values in the base tables.  Using the code book provided, it is converted to a factor of six levels ('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS','SITTING', 'STANDING', 'LAYING').

# Label the data set with descriptive variable names
Names for the 561 features are found in a separate file. These had to be normalized to conform to R naming rules and conventions.  Some names appeared to be in triplicate, and these were forced to be unique.

# Extracts only the measurements on the mean and standard deviation for each measurement
This resulted in a subset of 66 features.

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
Given the scope of the project, it is likely that the variables included (or excluded) could vary as the project progresses.  Hence a 'long' version of a tidy format was chosen, with the following columns:
subjectID, activityID, variableName, variableValue

Each row in this dataset represents the average value of each subject (subjectID) for each activity (activityID) for each selected feature (variableName) and the corresponding average value (variableValue).  Thus, for 30 subjects each having 6 activities, each measured using 66 features resulted in a dataset of 11880 observations.  This dataset is made available for further analysis as a comma-separated value text file ('har.sel.mean.tidy.txt').