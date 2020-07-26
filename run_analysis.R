
library(reshape2)
#Loading activity labels and features:

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

#Extracting only the measurements on the mean and standard deviation for each measurement:

wanted_features <- grep(".*mean.*|.*std.*", as.character(features[,2]))
names_features <- features[wanted_features,2]

#Modifying the names of the features:

names_features <- gsub("[-()]","",names_features)
names_features <- gsub("mean","Mean",names_features)
names_features <- gsub("std","Std",names_features)

#Loading training and test datasets:

train <- read.table("UCI HAR Dataset/train/X_train.txt")[wanted_features]
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[wanted_features]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

#Merging databases:

Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", names_features)

#Creating levels using subjects and activities as factors:
Data$activity <- factor(Data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
Data$subject <- as.factor(Data$subject)

Data_melted <- melt(Data, id = c("subject", "activity"))
Data_mean <- dcast(Data_melted, subject + activity ~ variable, mean)

write.table(Data_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
