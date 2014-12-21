# Getting & Cleaning Data Course Project

The R script run_analysis.R already has some self-explained comments within the code. Read the following content if you want to get more detailed information.

## General

According to the requirement of the project, the end result will only include the mean and standard deviation of each measurement, which means it's NOT necessary to load the raw data in the "Inertial Signals" folder. It will be much slower to load the raw signal data, and it's eventually useless.

To automate the process as much as possible, I also read the features.txt file to automatically fill column names of the feature measurements data, and read the activity_labels.txt file to automatically replace activity IDs with proper descriptive names. I used regular expressions to select mean and standard deviation columns and then replace these column names with more human friendly names.

## Step 1

The readData() function follows this logic: read subjects data as column "Subject", activity data as column "Activity" and feature data, and then use column bind to bind them into one data frame.

Use readData() function to read both train data and test data (apply column names read from features.txt to them), and use rbind to merge them into one data frame.

Here notice that when the feature names are applied to column names of data frame, they are changed. For example, "tBodyAcc-mean()-X" is changed to "tBodyAcc.mean...X".

## Step 2

Use regular expression ```(\\.mean\\.)|(\\.std\\.)``` to match column names, and only keep matched columns with "Subject" & "Activity".

Check https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html if you want to read more about regular expressions.

## Step 3

Map & replace activity IDs with corresponding labels according to activity_labels.txt.

## Step 4

Use regular expressions to match and replace column names to make them more readable.

For example, "tBodyAcc.mean...X" is replaced with "TimeDomain.BodyAccelerometer.Mean.X". Here TimeDomain stands for the type of the metrics, BodyAccelerometer for data source, Mean for aggregation method, and X for axial. Now the column names are well formatted and more human readable.

## Step 5

Leverage melt() and dcast() from the resharp2 library to reshape the data frame into narrow form first with "Subject" & "Activity" as id and others as variables, and then reshape it back to wide form with mean as aggregation method.

Use write.table() to output the result.

