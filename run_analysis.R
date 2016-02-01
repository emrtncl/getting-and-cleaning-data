#dplyr package is sourced in the script however aggregate function is used from stats package. Please note that there might be
#redundancies in the script. Also note that wd needs to be changed for the script to properly run. Please upload the UCI HAR Dataset
#folder to your working directory.

rm(list = setdiff(ls(), lsf.str())) #Clear out the global environment

setwd("C:/Users/i52062/Desktop/Stats/Getting_and_Cleaning_Data_3/Assignment")
library(dplyr)

#Import the train data into R
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Import the test data into R
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Get the features of interest into 
conn <- file("./UCI HAR Dataset/features.txt")
features <- readLines(conn)
close(conn)

mean_ind <- grep(pattern = "mean()",x = features,fixed = TRUE) #Column indexes for the mean calculation
std_ind <- grep(pattern = "std()",x = features,fixed = TRUE) #Column indexes for the standard deviation calculation

#Combine train and test data
combine_data <- rbind(x_test,x_train)
mean_data <- combine_data[,mean_ind]
std_data <- combine_data[,std_ind]


#Get the labels for the activities to match them to numeric values
conn <- file("./UCI HAR Dataset/activity_labels.txt")
activity_labels <- readLines(conn)
close(conn)

act_list <- strsplit(x = activity_labels,split = "^[0-9] ")
activity_vector <- character(length = length(activity_labels))

for(i in 1:length(act_list)){
  activity_vector[i]<- act_list[[i]][2] #Second element of each item of the list 
}

activity_vector <- gsub("_"," ",activity_vector)

#combine y_test and y_train
combine_y <- rbind(y_test,y_train)
activity_column <- ifelse(combine_y == 1,activity_vector[1],ifelse(combine_y == 2,activity_vector[2],ifelse(combine_y == 3,activity_vector[3],ifelse(combine_y == 4,activity_vector[4],ifelse(combine_y == 5,activity_vector[5],activity_vector[6])))))


#Assign column names to variables in the mean_data and std_data dataframes
mean_var <- features[mean_ind]
std_var <- features[std_ind]

mean_var <- gsub(pattern = "^[0-9]|[0-9]|[0-9] ",replacement = "",x = mean_var) #Replace numbers in the column names
mean_var <- gsub("^t","time",mean_var)
mean_var <- gsub("^f","frequency",mean_var)
mean_var <- gsub("-"," ",mean_var)

std_var <- gsub(pattern = "^[0-9]|[0-9]|[0-9] ",replacement = "",x = std_var) #Replace numbers in the column names
std_var <- gsub("^t","time",std_var)
std_var <- gsub("^f","frequency",std_var)
std_var <- gsub("-"," ",std_var)

colnames(mean_data) <- mean_var
colnames(std_data) <- std_var

#Combine test and train subjects
combine_subject <- rbind(subject_test,subject_train)

#Add subject and activity columns to mean and std dev data frames
mean_data <- cbind(combine_subject,activity_column,mean_data)
std_data <- cbind(combine_subject,activity_column,std_data)

colnames(mean_data) <- c("Subject","Activity",mean_var)
colnames(std_data) <- c("Subject","Activity",std_var)

compute_mean <- aggregate(mean_data,by=list(mean_data$Subject,mean_data$Activity),FUN = mean)
compute_mean <- compute_mean[,c(-3,-4)]
colnames(compute_mean) <- c("Subject","Activity",mean_var)

compute_std <- aggregate(std_data,by=list(std_data$Subject,std_data$Activity),FUN = sd)
compute_std <- compute_std[,c(-3,-4)]
colnames(compute_std) <- c("Subject","Activity",std_var)

#Combine mean and std calculations in a single data frame
clean_data <- cbind(compute_mean[,1:2],compute_mean[,3:ncol(compute_mean)],compute_std[,3:ncol(compute_std)])

write.table(x = clean_data,file = "upload.txt",row.names = FALSE)



