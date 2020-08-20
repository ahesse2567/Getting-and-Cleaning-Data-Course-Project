# Getting-and-Cleaning-Data-Course-Project

This file describes the run_analysis.R script. Note that explicit details and arguments for every function are provided in the run_analysis.R script file.

## Loading packages, creating directories, and downloading the data

The script begins by loading the tidyverse package. Next, it creates a raw data file if it doesn't already exist. After creating the raw data folder, the script downloads the zip file from the url. Finally, the script unzips the zip file if it doesn't already exist.

## Loading the data

This section describes loading the training set. Unless noted otherwise, loading the testing set was done in the same way but by chaining instances of "train" to "test". The following datasets were loaded with read.table()

- X_train.txt. This file includes the measures for the training dataset variables.
- features.txt. This file includes the names for the training dataset variables.

After loading those two datasets, the column names for the X_train.txt was set to the values from the features.txt dataset.

Next, the subject ID's were loaded with read.table() from the subject_train.txt file. Those values were then combined with the train file using cbind().

The activity numbers were then loaded with read.table() from the y_train.txt dataset. Since these were numbers instead of decriptive labels, we then loaded the activity_labels.txt with read.table(). After turning these activity names to lowercase with tolower(), we used mutate() and case_when(), both from the dplyr package to rename the activity labels to readable values.

## Combining data frames

Afterwards, we added the activity labels to the training data with cbind(). Finally, we created a a a character vector named setType equal to "train". setType and train were merged together with cbind().

After repeating the above steps for the testing dataset, the training and testing datasets were merged with rbind(). The next step is to extract only mean or standard deviation values. Looking at the list of column names, we find that any value with a mean value will have the word "mean" in its name. Also, any value with a standard deviation will have "std" in its name. We can use regular expressions and grep() to locate those columns and create a meanMeasures and stdMeasures data frames. We can then cbind() those data frames, the subject ID's, activities, and set types. Finally, we can write a text file with the tidy data using write.table().

## Writing the mean summary text file

Lastly, we can find the mean value for each participant and for each activity by means of group_by() and summarize_each(). Results of this data frame are then written to a text file with write.table().

