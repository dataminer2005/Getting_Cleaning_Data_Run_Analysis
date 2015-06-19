# Getting and Cleaning Data Coursera Course Week 3 Project - CodeBook
This file serves as CodeBook of Run_Analysis.R project which provides source of data, description of variables, data cleaning steps towards output files. 

* URL of source data
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
* Data for this project
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Data download, read and cleaining steps conducted via Run_Analysis.R - 6 steps
  *  Step 0: Set Working Directory
     * set up a working directory by the course name, check whether the directory exists, create it if        not - setwd("C:/Users/fangl_000/Desktop/Coursera/JHDS/3_Getting_cleaning_data/")
     
  *  Step 1: Merges the training and the test sets to create one data set.
     * 1.1 unzip and load the data
     * 1.2 read 3 sets of training and tesing data and then combine together
         - read "X_train.txt" & "X_test.txt" and rbind to create "datafile", a 10299x561 dataframe
         - read "y_train.txt" & "y_test.txt" and rbine to create "activity", a 10299x1 dataframe
         - read "subject_train.txt" & "subject_test.txt" and rbine to create "sbj", a 10299x1dataframe
     * 1.3 cbind above 3 data together to create base data - Run_data
     
   *  Step 2: Exetracts only the measurements on the mean and standard deviation for each measurement.               using the features vector to assign columns for datafile
     * assign column names then extrac only mead and std to create Run_data_meanStd data
     
   *  Step 3:  Uses descriptive activity names to name the activities in Run_data_meanStd data
   
   *  Step 4: Appropriately labels the data set with descriptive variable names and data cleaning
           1. # remove "()"
           2. make 'mean' and 'std' to uppercase 'Mean' and 'Std'
           3. change 'Freq' to 'Frequency' for clarity
           4. remove "BodyBody" and "Body" in names to simplify
           5. remove "-" in names
           6. write the first tidy data to working directory & name file as "1st_tidy_run_data.txt"
              -write.table(Run_data_meanStd, "1st_tidy_run_data.txt", row.names = FALSE) 
              
   *  Step 5: Calculate averages for each variable by subject and activity on Run_data_meanStd data
              and write output file to working directory and named as '"AvgRun_by_Activity_Subject                .txt"
              - write.table(AvgRun_by_act_sub, "AvgRun_by_Activity_Subject.txt", row.names = FALSE)
