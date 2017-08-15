# Assignement_Getting_and_cleaning_data

##Files in this Repository
*README.md - this file with project info
*CodeBook.md - list of variable used in project
*run_analisys - script for data analisys


##Description of run_analisys

###Load library 
The first step is to load needed library 
library(dplyr)
library(data.table)

###Download data and unzip 
This step download the dataset and unzip it on current working directory.

destination_file<-paste0(getwd(),"/","week4file.zip")

downloaded_file<-download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = destination_file)

unzip("week4file.zip",list = TRUE)

###Read files for data
Then the script reads data from files 

activity_labels<-read.table("activity_labels.txt")
features_names<-read.table("features.txt")
features_train<-read.table("./train/X_train.txt")
activities_train<-read.table("./train/Y_train.txt")
subjects_train<-read.table("./train/subject_train.txt")
features_test<-read.table("./test/X_test.txt")
activities_test<-read.table("./test/Y_test.txt")
subjects_test<-read.table("./test/subject_test.txt")

then renames columns subjects and activities

names(subjects_train)<-"subjects"
names(subjects_test)<-"subjects"

names(activities_test)<-"activities"
names(activities_train)<-"activities"

After this add two columns to datasets (subjects and activities)

features_train<-cbind(subjects_train,activities_train,features_train)
features_test<-cbind(subjects_test,activities_test,features_test)

###Merge the two datasets (Question 1)
features_merged<-rbind(features_train,features_test)
names(features_merged)<-c(names(features_merged[1:2]),as.character(features_names$V2))

###Get only Mean and STD measurement (Question 2)
Mean_STD_columns <- grep("-mean\\(\\)|-std\\(\\)|subjects|activities", names(features_merged))
features_merged_Mean_STD<-features_merged[,Mean_STD_columns]

###Rename activity with description (Question 3)
features_merged_Mean_STD<-mutate(features_merged_Mean_STD,activities=factor(activities,levels = 1:6,labels = activity_labels$V2))

###Rename data set labels with descriptive variable names based on features_info.txt  (Question 4)

names(features_merged_Mean_STD) <- names(features_merged)[Mean_STD_columns]
names(features_merged_Mean_STD) <- gsub("\\(|\\)", "", names(features_merged_Mean_STD))
names(features_merged_Mean_STD)<-gsub('-mean', 'Mean', names(features_merged_Mean_STD))
names(features_merged_Mean_STD) <- gsub('-std', 'Std', names(features_merged_Mean_STD))

###Create independent tidy data set with the average of each variable for each activity and each subject (Question 5)
tidy<-features_merged%>%group_by(subjects,activities)%>%summarise_all(mean)
write.table(tidy,"Week4Peer_TidyData.txt",row.names = FALSE)


