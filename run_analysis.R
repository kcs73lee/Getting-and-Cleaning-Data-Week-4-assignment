# Getting-and-Cleaning-Data-Week-4-assignment
Week 4
##download file
if(!file.exists("./dat")){dir.create("./dat")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./dat/Dataset.zip")

##unzip file
unzip(zipfile = "./dat/Dataset.zip", exdir="./dat")

##read files
actlabels<-read.table("./dat/UCI HAR Dataset/activity_labels.txt")
featnames<-read.table("./dat/UCI HAR Dataset/features.txt")
xtrain<-read.table("./dat/UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("./dat/UCI HAR Dataset/train/y_train.txt")
subtrain<-read.table("./dat/UCI HAR Dataset/train/subject_train.txt")
xtest<-read.table("./dat/UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("./dat/UCI HAR Dataset/test/y_test.txt")
subtest<-read.table("./dat/UCI HAR Dataset/test/subject_test.txt")

##meaningful col names
colnames(xtrain)<- features[,2]
colnames(ytrain)<- "activity"
colnames(subtrain)<- "subject"  
colnames(xtest)<- features[,2]  
colnames(ytest)<- "activity" 
colnames(subtest)<- "subject"
colnames(actlabels)<-c("activity","ActType")

## Merges the training and the test sets to create one data set
trainmerge<-cbind(ytrain, subtrain, xtrain)
testmerge<-cbind(ytest, subtest, xtest)
Allmerge<-rbind(trainmerge, testmerge) 

## Extracts only the measurements on the mean and standard deviation for each treatment
Cnames<- colnames(Allmerge)
mean_sd<- (grepl("activity", Cnames)|grepl("subject", Cnames)|grepl("mean", Cnames)|grepl("sd", Cnames))
datset_mean_sd<-Allmerge[ ,mean_sd==TRUE]

##Uses descriptive activity names to name the activities in the data set
datset_actnames<- merge(datset_mean_sd, actlabels, by= "activity", all.x= TRUE)

##appropriately labels the data set with descriptive variable names
# Using names from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
names(datset_actnames)<- gsub("^t","time", names(datset_actnames))
names(datset_actnames)<- gsub("^f","frequency", names(datset_actnames))
names(datset_actnames)<- gsub("Acc","Accelerometer", names(datset_actnames))
names(datset_actnames)<- gsub("Gyro","Gyroscope", names(datset_actnames))
names(datset_actnames)<- gsub("Mag","Magnitude", names(datset_actnames))
names(datset_actnames)<- gsub("BodyBody","body", names(datset_actnames))

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidydat<- aggregate(. ~subject+ activity, datset_actnames, mean)
tidydat<- tidydat[order(tidydat$subject, tidydat$activity),]
write.table(tidydat, file= "tidydat.txt", row.name= FALSE, col.names = TRUE)

## Complete
