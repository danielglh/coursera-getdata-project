library(reshape2)

# This function is used to read train & test data
readData <- function(group, colNames) {
    # Read subject data
    subjectDataFile <- paste(group, "/subject_", group, ".txt", sep="")
    subjectData <- read.table(subjectDataFile, col.names="Subject")
    # Read activity data
    activityDataFile <- paste(group, "/y_", group, ".txt", sep="")
    activityData <- read.table(activityDataFile, col.names="Activity")
    # Read features data
    featureDataFile <- paste(group, "/X_", group, ".txt", sep="")
    featureData <- read.table(featureDataFile, col.names=colNames)
    # Combine them with column binding
    cbind(subjectData, activityData, featureData)
}

# This function is used to generated human friendly column names
humanizeVariableNames <- function(names) {
    # Remove ".."
    names <- sub("\\.\\.", "", names)
    # Replace leading "t" with "TimeDomain."
    names <- sub("^t", "TimeDomain.", names)
    # Replace leading "f" with "FrequencyDomain."
    names <- sub("^f", "FrequencyDomain.", names)
    # Replace "Acc" with "Accelerometer"
    names <- sub("Acc", "Accelerometer", names)
    # Replace "Gyro" with "Gyroscope"
    names <- sub("Gyro", "Gyroscope", names)
    # Replace "Mag" with "Magnitude"
    names <- sub("Mag", "Magnitude", names)
    # Replace "mean" with "Mean"
    names <- sub("mean", "Mean", names)
    # Replace "std" with StandardDeviation""
    names <- sub("std", "StandardDeviation", names)
    names
}

# Step 1: read and merge training and test sets into one data frame
features <- read.table("features.txt", col.names=c("Index","Name"))
trainData <- readData("train", features$Name)
testData  <- readData("test", features$Name)
allData <- rbind(trainData, testData)

# Step 2: extract only mean and standard deviation for each measurement
selectedColumns <- grep("(\\.mean\\.)|(\\.std\\.)", names(allData), value=TRUE)
selectedData <- allData[, c("Subject","Activity",selectedColumns)]

# Step 3: replace activity IDs with descriptive activity names
activities <- read.table("activity_labels.txt", col.names=c("ID","Label"))
activityIds <- as.numeric(as.character(selectedData$Activity))
selectedData$Activity <- activities$Label[activityIds]

# Step 4: label the features with descriptive variable names (subject and activity already have proper name)
names(selectedData) <- humanizeVariableNames(names(selectedData))

# Step 5: write the tidy data set to a file
seletedDataMelt <- melt(selectedData, id=c("Subject","Activity"))
averageData <- dcast(seletedDataMelt, Subject + Activity ~ variable,mean)
write.table(averageData, file="clean_data.txt", row.names=FALSE)
