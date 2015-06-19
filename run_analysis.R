## This is course project for Coursera Course - Getting and Cleaning Data
## You should create one R script called run_analysis.R that does the following.
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the
##    average of each variable for each activity and each subject.
#####################################################
## Step 0: Set Working Directory
####################################################
list.files()
if(!file.exists("C:/Users/fangl_000/Desktop/Coursera/JHDS/3_Getting_cleaning_data/"))
        {
        dir.create("C:/Users/fangl_000/Desktop/Coursera/JHDS/3_Getting_cleaning_data/")
        }
getwd()

setwd("C:/Users/fangl_000/Desktop/Coursera/JHDS/3_Getting_cleaning_data/")
getwd()

#############################################################################
## Step 1: Merges the training and the test sets to create one data set.
################################################################################

           # 1.1 unzip and load the data
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file.dest <- "infile.zip"
download.file(file.url, file.dest)
dateDownloaded <- date()
dateDownloaded
unzip("infile.zip")
## [1] "Tue Jun 16 21:29:54 2015"
        # 1.2 review file in notepad++ and there are 3 sets of data for both training and testing data,
        #        read 3 sets of data and then combine together

df1 <- read.table("UCI HAR Dataset/train/X_train.txt")
df2 <- read.table("UCI HAR Dataset/test/X_test.txt")
datafile <- rbind(df1, df2)
dim(datafile)
## [1] 10299   561
head(datafile, n=3)
tail(datafile, n=3)
## create activity vector - y-
df1 <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
df2 <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
activity <- rbind(df1, df2)
dim(activity)
## [1] 10299     1
head(activity, n=3)
## create subject vector - sbj
df1 <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
df2 <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
sbj <- rbind(df1, df2)
dim(sbj)
# read two lable files

features <- read.table("UCI HAR Dataset/features.txt", colClasses = c("character"))
activity_lable <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityId", "Activity"))
head(activity_lable, n=3)

#  1.3 merge training and testing file into one file - Run_data
# datafile has 561 columns, col562 is subject var, col563 is activityID. will be used in  Step 2

Run_data <- cbind(cbind(datafile, sbj), activity)
dim(Run_data)
# [1] 10299   563
head(Run_data, n=1)
#####################################################################################################
## Step 2: exetracts only the measurements on the mean and standard deviation for each measurement.
##         using the features vector to assign columns for datafile
####################################################################################################

## assign column names using features vector
head(features, n=3)

names(Run_data) <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]

head(Run_data, n=1)
##  extract only mean and std
Run_data_meanStd <- Run_data[,grepl("mean|std|Subject|ActivityId", names(Run_data))]
head(Run_data_meanStd, n=1)

length(Run_data_meanStd) # 81

####################################################################################
# Step 3:  Uses descriptive activity names to name the activities in the data set
####################################################################################

Run_data_meanStd_ori <- join(Run_data_meanStd, activity_label, by = "ActivityId", match = "first")
# remove activityID after join
Run_data_meanStd <- Run_data_meanStd_ori[,-1]
head(Run_data_meanStd, n=1)
# make tidy data - data cleaning
names(Run_data_meanStd) <- gsub('\\(|\\)',"",names(Run_data_meanStd), perl = TRUE) # remove "()"
names(Run_data_meanStd) <- gsub('\\-mean',"-Mean",names(Run_data_meanStd))  # capitalize M
names(Run_data_meanStd) <- gsub('\\-std',"-StandardDeviation",names(Run_data_meanStd)) # capitalize S
names(Run_data_meanStd) <- gsub('\\Freq.',"Frequency.",names(Run_data_meanStd))
names(Run_data_meanStd) <- gsub('Freq\\',"Frequency",names(Run_data_meanStd))
names(Run_data_meanStd) <- gsub('BodyBody',"",names(Run_data_meanStd)) # remove "BodyBody"
names(Run_data_meanStd) <- gsub('Body',"",names(Run_data_meanStd)) # remove "Body"
names(Run_data_meanStd) <- gsub("-", "", names(Run_data_meanStd)) # remove "-" in column names
head(Run_data_meanStd, n=1)
dim(Run_data_meanStd)   # [1] 10299    81
# write out the table
write.table(Run_data_meanStd, "1st_tidy_run_data.txt", row.names = FALSE) # write out the 1st dataset

##############################################################################################
## Step 5. Calculate averages for each variable by subject and activity.
###########################################################################################

AvgRun_by_act_sub = ddply(Run_data_meanStd, c("Subject","Activity"), numcolwise(mean))
dim(AvgRun_by_act_sub)   # [1] 180  81
head(AvgRun_by_act_sub, n=2)
cat("\014")  # clean up console
write.table(AvgRun_by_act_sub, "AvgRun_by_Activity_Subject.txt", row.names = FALSE)
