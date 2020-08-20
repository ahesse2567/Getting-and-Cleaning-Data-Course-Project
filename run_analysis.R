library(tidyverse)

if(!file.exists("data_raw")) {
    dir.create("data_raw")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "data_raw/activity.zip", method = "curl")
dateDownloaded <- date()
dateDownloaded

if(!file.exists("UCI HAR Dataset")) {
    unzip("data_raw/activity.zip")
}

#### TRAINING SET ############################################################

# load training set
train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
dim(train)
str(train)

# load feature names
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE,
                       col.names = c("feature_number", "feature_name"))
dim(features)
str(features)

# add feature names to column names of training set
colnames(train) <- features$feature_name
names(train)

# load subjects
subjectsTrain <- read.table("UCI HAR Dataset/train/subject_train.txt",
                       header = FALSE, col.names = "subject_id")
head(subjectsTrain)
tail(subjectsTrain)
dim(subjectsTrain)

# cbind subject id's to training set
if(!any(colnames(train) == "subject_id")) {
    train <- cbind(subjectsTrain, train)
}

# load activities
activitiesTraining <- read.table("UCI HAR Dataset/train/y_train.txt",
                                 header = FALSE, col.names = c("activity"))
dim(activitiesTraining)
colnames(activitiesTraining)

# load activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",
                             header = FALSE,
                             col.names = c("activity_number", "activity_name"))
# make activity names lowercase for ease of typing
activityLabels$activity_name <- tolower(activityLabels$activity_name)
dim(activityLabels)

# we found out later that there are some duplicate column names, so in order to recode the numbers as the activity label names we need to do so BEFORE cbinding the activities with the entire training set.

duiplicateNames <- which(duplicated(colnames(train)))
sort(colnames(train)[duiplicateNames])

activitiesTraining <- activitiesTraining %>% 
    mutate(activity = case_when(
        activity == 1 ~ activityLabels$activity_name[1],
        activity == 2 ~ activityLabels$activity_name[2],
        activity == 3 ~ activityLabels$activity_name[3],
        activity == 4 ~ activityLabels$activity_name[4],
        activity == 5 ~ activityLabels$activity_name[5],
        activity == 6 ~ activityLabels$activity_name[6]
    )) %>% 
    print

# cbind subject id's to training set
if(!any(colnames(train) == "activity")) {
    train <- cbind(activitiesTraining, train)
}

if(!any(colnames(train) == "setType")) {
    setType <- rep("train", nrow(train))
    train <- cbind(setType, train)
}


#### TESTING SET ############################################################


# load training set
test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
dim(test)
str(test)

# load feature names
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE,
                       col.names = c("feature_number", "feature_name"))
dim(features)
str(features)

# add feature names to column names of testing set
colnames(test) <- features$feature_name
names(test)

# load subjects
subjectsTest <- read.table("UCI HAR Dataset/test/subject_test.txt",
                       header = FALSE, col.names = "subject_id")
head(subjectsTest)
tail(subjectsTest)
dim(subjectsTest)

# cbind subject id's to testing set
if(!any(colnames(test) == "subject_id")) {
    test <- cbind(subjectsTest, test)
}

# load activities
activitiesTesting <- read.table("UCI HAR Dataset/test/y_test.txt",
                                 header = FALSE, col.names = c("activity"))
dim(activitiesTesting)
colnames(activitiesTesting)

# load activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",
                             header = FALSE,
                             col.names = c("activity_number", "activity_name"))
# make activity names lowercase for ease of typing
activityLabels$activity_name <- tolower(activityLabels$activity_name)
dim(activityLabels)

# we found out later that there are some duplicate column names, so in order to recode the numbers as the activity label names we need to do so BEFORE cbinding the activities with the entire testing set.

duiplicateNames <- which(duplicated(colnames(test)))
sort(colnames(test)[duiplicateNames])

activitiesTesting <- activitiesTesting %>% 
    mutate(activity = case_when(
        activity == 1 ~ activityLabels$activity_name[1],
        activity == 2 ~ activityLabels$activity_name[2],
        activity == 3 ~ activityLabels$activity_name[3],
        activity == 4 ~ activityLabels$activity_name[4],
        activity == 5 ~ activityLabels$activity_name[5],
        activity == 6 ~ activityLabels$activity_name[6]
    ))

# cbind subject id's to testing set
if(!any(colnames(test) == "activity")) {
    test <- cbind(activitiesTesting, test)
}

if(!any(colnames(test) == "setType")) {
    setType <- rep("test", nrow(test))
    test <- cbind(setType, test)
}

### combine training and testing sets
dim(train)
dim(test)
combined <- rbind(train, test)
dim(combined)

##############################################################################
# Extracts mean and sd values

meanMeasures <- combined[,grep("[mM]ean", colnames(combined))]
stdMeasures <- combined[,grep("[sS]td", colnames(combined))]
meanStdMeasures <- cbind(meanMeasures, stdMeasures)
meanStdMeasures <- cbind(combined$subject_id, combined$activity,
                     combined$setType, meanStdMeasures)
meanStdMeasures <- meanStdMeasures %>% 
    rename("subject_id" = "combined$subject_id",
           "activity" = "combined$activity",
           "set_type" = "combined$setType")
colnames(meanStdMeasures)[1:3]

write.table(meanStdMeasures, "tidyData.txt", sep = "\t", row.name = FALSE)


#### mean summary
meanSmry <- meanStdMeasures %>% 
    group_by(activity, subject_id) %>% 
    summarize_each(funs(mean), -set_type)
View(meanSmry)

write.table(meanStdMeasures, "meanSmry.txt", sep = "\t", row.name = FALSE)
