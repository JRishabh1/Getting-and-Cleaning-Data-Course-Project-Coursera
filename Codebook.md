# The codebook for the tidy data set
## General info

You can read in the tidy data set tidy_data.txt into R via read.table("tidy_data.txt"). This creates a table with the dimensions 181 x 81. The first column is the subject, i.e. the person using the device. The second column shows the activity. The next columns show the accelerometer and gyroscope data. A list of these features can be found in the feature list.

## How the data are transformed by the script:

1. The data are read in and simplified for processing
2. We define the important features (impFeatures), i.e standard deviation and mean.
3. Only the data relevant for the standard deviations and means are read in to memory (this results in a table with 66 rows).
4. Perform steps 1-3 for the test and the training set.
5. Transform activity names into factors.
6. Reshape the data so that subjects and activities become a variables of two independent columns.
7. Finally save the data.
