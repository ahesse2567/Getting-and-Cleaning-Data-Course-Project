# Getting-and-Cleaning-Data-Course-Project

## Description of Data

Note, the following information is a modified copy of the original README.txt file found in the UCI HAR Dataset folder. The modifications include descriptions of "tidyData.txt" and "meanSmry.txt". Continue beyond the description of data for an overview of how the run_analysis.R script functions.


### Human Activity Recognition Using Smartphones Dataset
Version 1.0

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### The dataset includes the following files:

- 'README_codebook.txt'

- 'tidyData.txt': This dataset contains combined training and testing sets but with only the mean and standard deviation values for each of the features within the 'features_info.txt' file. This dataset also includes subject ID's, activities named lables, and indicates if the the data came from the training or testing dataset.

- 'meanSmry.txt' This is similar to the 'tidyData.txt' file except the data is summarized by acticity type and by participant.

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

### License:

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.



## Loading packages, creating directories, and downloading the data

This file describes the run_analysis.R script. Note that explicit details and arguments for every function are provided in the run_analysis.R script file.

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

