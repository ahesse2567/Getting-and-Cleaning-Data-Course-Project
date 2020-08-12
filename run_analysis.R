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

train <- read