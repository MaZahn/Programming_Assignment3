The dataset uses the following files from the original data set:
=========================================

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

#########
# NOTE:
the study subjects get arbitrary character names to enhance readability of the data set


The files are read and merged for the train and for the test data respectively and then rbinded.  Each row contains an arbitrary subject name and activity name along with those variables that contain the strings Mean, mean or std in their names.


########
# FINAL DATA SET
file ProgrammingAssignment_Week4.txt contains subject names, activities and averages of variables of those rows where activies are greater than 0. 



