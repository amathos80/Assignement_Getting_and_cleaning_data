#load needed library
library(dplyr)
library(data.table)
#set destination file
destination_file<-paste0(getwd(),"/","week4file.zip")
#download requested file
downloaded_file<-download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = destination_file)
#unzip the file
unzip("week4file.zip",list = TRUE)

## ------Resolve question 1----- 

#read activity_labels, features_names, subjects and data for train and test
activity_labels<-read.table("activity_labels.txt")
features_names<-read.table("features.txt")
features_train<-read.table("./train/X_train.txt")
activities_train<-read.table("./train/Y_train.txt")
subjects_train<-read.table("./train/subject_train.txt")
features_test<-read.table("./test/X_test.txt")
activities_test<-read.table("./test/Y_test.txt")
subjects_test<-read.table("./test/subject_test.txt")


#rename column of subjects set (test and train)
names(subjects_train)<-"subjects"
names(subjects_test)<-"subjects"

#rename column of subjects set (test and train)
names(activities_test)<-"activities"
names(activities_train)<-"activities"

#add subjects and activities columns to feature dataset (train and test)
features_train<-cbind(subjects_train,activities_train,features_train)
features_test<-cbind(subjects_test,activities_test,features_test)

#finally merge the two datasets
features_merged<-rbind(features_train,features_test)
names(features_merged)<-c(names(features_merged[1:2]),as.character(features_names$V2))

##------ end question 1 --------

## ------Resolve question 2----- 
#get only Mean and STD measurement
Mean_STD_columns <- grep("-mean\\(\\)|-std\\(\\)|subjects|activities", names(features_merged))
features_merged_Mean_STD<-features_merged[,Mean_STD_columns]

## ------- end question 2 -------

## ------Resolve question 3----- 
#rename activity with description
features_merged_Mean_STD<-mutate(features_merged_Mean_STD,activities=factor(activities,levels = 1:6,labels = activity_labels$V2))
## ------- end question 3 -------


## ------Resolve question 4----- 
#rename data set labels with descriptive variable names based on features_info.txt 
names(features_merged_Mean_STD) <- names(features_merged)[Mean_STD_columns]
names(features_merged_Mean_STD) <- gsub("\\(|\\)", "", names(features_merged_Mean_STD))
names(features_merged_Mean_STD)<-gsub('-mean', 'Mean', names(features_merged_Mean_STD))
names(features_merged_Mean_STD) <- gsub('-std', 'Std', names(features_merged_Mean_STD))
## ------- end question 4 -------


## ------Resolve question 5----- 
tidy<-features_merged_Mean_STD%>%group_by(subjects,activities)%>%summarise_all(mean)
write.table(tidy,"Week4Peer_TidyData.txt",row.names = FALSE)
## ------- end question 5 -------
  