The goal of `run_analysis.R` script is to prepare tidy data that can be used for later analysis. the `dplyr` package is loaded into R for this purpose.
The raw data for this project is downloaded from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) using the `download.file()` function. This file is then unzipped using the `unzip()` function. If statements are used to control whether the file is already downloaded and unzipped or not.

**reading the datasets into R**
- the `features.txt` dataset contains the features which come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. This data is assigned to the ` features` variable. It has *561 rows and 1 column*.
- 'activity_labels.txt': Links the class labels with their activity names, and is assigned to the ` activity_labels` variable. It has *6 rows and 2 columns*.
- `subject_train.txt` identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. This dataset is assigned to the `train_subject` variable. It has * 7352 rows and 1 column*.
- `X_train.txt` dataset contains the training set, and is assigned to the `train_set` variable. It has * 7352 rows and 561columns*.
- `y_train.txt` dataset contains the training labels, and is assigned to the `train_labels` variable. It has * 7352 rows and 1 column*.
- the Datasets `subject_test.txt`, `X_test.txt`, and `y_test.txt` contain the same information as our training datasets, except that now they represent our test data. they are assigned to `test_subject`, `test_set`, and `test_labels` variables and have *2947 rows and 1 column*, *2947 rows and 561 columns*, and *2947 rows and 1 column* respectively.

the first column of `features` is assigned to the column names of the 'train_set' and the 'test_set'.

the rest of the script is allocated to the steps mentioned below.
1. The training and the test sets are merged to create one data set assigned to the `merged_train_test` variable *(10299 rows and 563 columns)*.

- `set` variable is ` train_set` and ` test_set` variables merged together.
- `labels` variable is ` train_ labels` and ` test_ labels` variables merged together.
- `subject` variable is ` train_ subject` and ` test_ subject` variables merged together.
- `merged_train_test` variable is `subject`, `set`, and `labels` variables merged together.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 
- `extracted_data` *(10299 rows and 88 columns)*.is the extracted columns of `merged_train_test` which have "mean" or "std" characters in their column name, regardless of being whether lower cased or upper cased. the `grep()` function is used for this purpose. the `subject and ` label` columns are also included. 

3. Uses descriptive activity names to name the activities in the data set
- The `label` column in `extracted_data` is changed from numbers to activity names using the `activity_labels` variable.

4. Appropriately labels the data set with descriptive variable names. 
- the `gsub()` function is used to find and replace the characters that are not clear to the user. For example: "fBodyBodyAccJerkMag-std()" is changed to "FrequencyuencyDomainBodyAccelerometerJerkMagnitudeSTD"

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- The `extracted_data` is grouped by `subject` and `Activity` using the function `group_by()` and summarized using the `summarise_all()` and `mean()` functions and the result is assigned to the `RequiredData` variable *(180 rows and 88 columns)*. 

