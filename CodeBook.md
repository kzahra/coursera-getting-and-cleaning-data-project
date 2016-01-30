# Code Book

The run_analysis script performs all the tasks required in the Getting and Cleaning Data Course Project. These include:
  - Merges the training and the test sets to create one data set.
  - Extracts only the measurements on the mean and standard deviation for each measurement.
  - Uses descriptive activity names to name the activities in the data set
  - Appropriately labels the data set with descriptive variable names.
  - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Sections
All the code is commented with section numbers in order to provide better segregation. The sections range from 0-5. All the sections are described below.

### Section 0
In this section the following steps are performed
  - Set the file name (variable: `file_name`)
  - Download file if it does not exist in working directory
  - Unzip file if the "UCI HAR Dataset" does not exist in working directory

### Section 1
In this section the following steps are performed
  - Load activity and features and set column names (files: `activity_labels.txt`,`features.txt`; variables: `activity`,`features`)
  - Load training dataset and set column names (files: `subject_train.txt`,`x_train.txt`,`y_train.txt`; variables: `subject_train`,`x_train`,`y_train`)
  - Merge the training data into one dataset (variables: `training_dataset`)
  - Load test data and set column names  (files: `subject_test.txt`,`x_test.txt`,`y_test.txt`; variables: `subject_test`,`x_test`,`y_test`)
  - Merge the test data into one dataset (variables: `test_dataset`)
  - Union the training and test datasets to create one dataset (variables: `all_dataset`)

### Section 2
In this section the following steps are performed
  - Get column names (variable: `col_names`)
  - Create a logicalVector containing TRUE values for required columns and FALSE for others (variable: `l_vector`)
  - Unzip file if the "UCI HAR Dataset" does not exist in working directory
  - Keep only required columns based on the logical vector TRUE values
  - Merge the dataset with the activity table to name the activities in the dataset
  - Update the `col_names` vector to include the new activity column

### Section 3
In this section the following steps are performed
  - Cleaning the variable names by using the `gsub()` function
  - Reassign cleansed variable names to dataset

### Section 4
In this section the following steps are performed
  - Create a new table excluding the activityType column (variable: `all_dataset_exc_activityType`)
  - Summarize the dataset to include the average of each variable grouped by activity and subject (variable: `tidy_dataset`)
  - Merge the tidy dataset with activity to include the activity names

### Section 5
In this section the following steps are performed
  - Export the tidyData set by using the `write.table()` function 