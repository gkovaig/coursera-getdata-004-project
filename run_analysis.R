# Project work for Johns Hopkins School of Public Health / Coursera
# Getting and Cleaning Data - https://class.coursera.org/getdata-004/
# Submitted by Raj Manickam on 2014-06-10
sessionInfo()
setwd('~/appdev/jhsph/getdata/project/coursera-getdata-004-project/UCI HAR Dataset/')
library(data.table)
har.train = read.table('train/X_train.txt', header = FALSE, na.strings = 'N/A', stringsAsFactors = FALSE)
str(har.train) # 7352 obs, 561 vars
head(har.train[,c(1:5)])
#
subject.train = read.table('train/subject_train.txt', header = FALSE, stringsAsFactors = FALSE, colClasses = c('character'))
table(subject.train$V1)
activity.train = read.table('train/y_train.txt', header = FALSE, stringsAsFactors = FALSE, colClasses = c('character'))
table(activity.train$V1)
#
har.test = read.table('test/X_test.txt', header = FALSE, na.strings = 'N/A', stringsAsFactors = FALSE)
str(har.test) # 2947 obs, 561 vars
head(har.test[,c(1:5)])
#
subject.test = read.table('test/subject_test.txt', header = FALSE, stringsAsFactors = FALSE, colClasses = c('character'))
str(subject.test)
table(subject.test$V1)
#
activity.test = read.table('test/y_test.txt', header = FALSE, stringsAsFactors = FALSE, colClasses = c('character'))
table(activity.test$V1)
#
# Merges the training and the test sets to create one data set
har.all = rbind(har.train, har.test) # 10299 x 561
subject.all = rbind(subject.train, subject.test)
setnames(subject.all, 'V1', 'subjectID')
activity.all = rbind(activity.train, activity.test)
setnames(activity.all, 'V1', 'activityID')
har.all = cbind(har.all, subject.all, activity.all)
#
# Check for missing values
sum(complete.cases(har.all)) # 10299 - no missing values
#
# Uses descriptive activity names to name the activities in the data set
table(har.all$activityID)
har.all$activityID = as.factor(har.all$activityID)
levels(har.all$activityID) = c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS','SITTING', 'STANDING', 'LAYING')
#
# Appropriately labels the data set with descriptive variable names
colNames = read.table('features.txt', header = FALSE, stringsAsFactors = FALSE)
head(colNames)
#
colNames.std = gsub('(', '', colNames$V2, fixed = TRUE)
colNames.std = gsub(')', '', colNames.std, fixed = TRUE)
colNames.std = gsub(',', '.', colNames.std, fixed = TRUE)
colNames.std = gsub('-', '.', colNames.std, fixed = TRUE)
colNames.std = make.names(colNames.std, unique = TRUE, allow_ = FALSE)
# Notice triples in some names which are forced to be unique
# Likely X,Y,Z axes, but cannot verify independently without confirmation from data collector
# Analysis will not be hindered; will leave names as-is
names(har.all) = c(colNames.std, 'subjectID', 'activityID')
#
# Extracts only the measurements on the mean and standard deviation for each measurement
# i.e. has -mean() or -std() in name
# Assumption: meanFreq should *not* match
selColumns = grep('mean\\(\\)|std\\(\\)', colNames$V2, perl=TRUE, value=FALSE)
# 66 columns qualify
har.sel = har.all[, c(selColumns, 562, 563)] # 10299 obs x 68 vars, including subjectID and activityID
tail(har.sel)
#
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
# Need: subjectID, activityID, variableName, variableValue
# http://stackoverflow.com/questions/21295936/can-dplyr-summarise-over-several-variables-without-listing-each-one
#
library(dplyr)
har.sel.grouped = group_by(har.sel, subjectID, activityID)
columns = names(har.sel)[1:66]
dots = lapply(columns, function(x) substitute(mean(x), list(x = as.name(x))))
har.sel.mean = do.call(summarise, c(list(.data = har.sel.grouped), dots))
# 
library(reshape2)
har.sel.mean.tidy = melt(har.sel.mean,
    id.vars = c('subjectID', 'activityID'),
    variable.name = 'variableName',
    value.name = 'variableValue'
)
write.table(har.sel.mean.tidy, file = 'har_sel_mean_tidy.csv', append = FALSE, quote = TRUE,
            sep = ',', row.names = FALSE)
#
# Sample Test Code
# summary(har.sel[har.sel$subjectID == '9' & har.sel$activityID == 'STANDING',c(1:3)])