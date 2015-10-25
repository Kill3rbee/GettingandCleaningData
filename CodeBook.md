## CodeBook
*************
This document describes the data, transformations and definition of variable used within run_analysis.R script to generate Tidy.csv.

## Dataset Used
****************
The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (`WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`) wearing a smartphone (Samsung Galaxy S II) on the waist. A full description is available at the site http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The data set used can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

## Input Dataset Used
**********************
The input data containts the following data files:

* **X_train.txt** contains variable features that are intended for training.
* **y_train.txt** contains the activities corresponding to **X_train.txt**.
* **subject_train.txt** contains information on the subjects from whom data is collected.
* **X_test.txt** contains variable features that are intended for testing.
* **y_test.txt** contains the activities corresponding to **X_test.txt**.
* **subject_test.txt** contains information on the subjects from whom data is collected.
* **activity_labels.txt** contains metadata on the different types of activities.
* **features.txt** contains the name of the features in the data sets.

## Transformations Performed
****************************
Following are the transformations that were performed on the input dataset:

* **X_train.txt** is read into **featuresTrain**.
* **y_train.txt** is read into **activityTrain**.
* **subject_train.txt** is read into **subjectTrain**.
* **X_test.txt** is read into **featuresTest**.
* **y_test.txt** is read into **activityTest**.
* **subject_test.txt** is read into **subjectTest**.
* **features.txt** is read into **featureNames**.
* **activity_labels.txt** is read into **activityLabels**.
* The subjects in training and test set data are merged to form **subject**.
* The activities in training and test set data are merged to form **activity**.
* The features of test and training are merged to form **features**.
* The name of the features are set in **features** from **featureNames**.
* **features**, **activity** and **subject** are merged to form **completeData**.
* Indices of columns that contain std or mean, activity and subject are extracted into **requiredColumns**.
* **extractedData** is created with data from columns in **requiredColumns**.
* **Activity** column in **extractedData** is updated with descriptive names of activities taken from **activityLabels**. 
* **Activity** column is expressed as a factor variable.
* Acronyms such as `'Acc'`, `'Gyro'`, `'Mag'`, `'t'` and `'f'` used as part of variable names in **extractedData** are replaced with descriptive labels such as `'Accelerometer'`, `'Gyroscpoe'`, `'Magnitude'`, `'Time'` and `'Frequency'`.
* **tidyData** is created as a data set with average for each activity and subject of **extractedData**. Entries in **tidyData** are ordered based on activity and subject.
* Finally, the data in **tidyData** is written into **Tidy.csv**.

## Output Data Set
*******************
The output data **Tidy.csv** is a a comma-delimited file.