##Section 0
#Set file name
file_name <- "getdata_dataset.zip"

#Download file if it does not exist in working directory
if (!file.exists(filename)){
  file_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(file_URL, file_name, method="curl")
}  
#Unzip file if the "UCI HAR Dataset" does not exist in working directory
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

##Section 1
#Load activity and features and set column names
activity <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)
colnames(activity)  = c('activityId','activityType');

features <- read.table("UCI HAR Dataset/features.txt", header=FALSE)

#Load training dataset and set column names
subject_train = read.table('UCI HAR Dataset/train/subject_train.txt',header=FALSE); 
colnames(subject_train)  = "subjectId";

x_train = read.table('UCI HAR Dataset/train/x_train.txt',header=FALSE); 
colnames(x_train) = features[,2]; 

y_train = read.table('UCI HAR Dataset/train/y_train.txt',header=FALSE); 
colnames(y_train)  = "activityId";

#Merge the training data into one dataset
training_dataset = cbind(y_train,subject_train,x_train);

#Load test data and set column names
subject_test = read.table('UCI HAR Dataset/test/subject_test.txt',header=FALSE); 
colnames(subject_test) = "subjectId";

x_test = read.table('UCI HAR Dataset/test/x_test.txt',header=FALSE); 
colnames(x_test) = features[,2]; 

y_test = read.table('UCI HAR Dataset/test/y_test.txt',header=FALSE); 
colnames(y_test) = "activityId";

#Merge the test data into one dataset
test_dataset = cbind(y_test,subject_test,x_test);

#Union the training and test datasets to create one dataset
all_dataset = rbind(training_dataset,test_dataset);

##Section 2
#Get columns names
col_names = colnames(all_dataset); 

#Create a logicalVector containing TRUE values for required columns and FALSE for others
l_vector = (grepl("activity..",col_names) | grepl("subject..",col_names) | grepl("-mean..",col_names) & !grepl("-meanFreq..",col_names) & !grepl("mean..-",col_names) | grepl("-std..",col_names) & !grepl("-std()..-",col_names));

#Keep only required columns based on the logical vector TRUE values
all_dataset = all_dataset[l_vector==TRUE];

#Merge the dataset with the acitivity table to name the activities in the dataset
all_dataset = merge(all_dataset,activity,by='activityId',all.x=TRUE);

#Update the col_names vector to include the new activity column
col_names  = colnames(all_dataset); 

##Section 3
#cleaning the variable names
for (i in 1:length(col_names)) 
{
  col_names[i] = gsub("\\()","",col_names[i])
  col_names[i] = gsub("-std$","StandardDev",col_names[i])
  col_names[i] = gsub("-mean","Mean",col_names[i])
  col_names[i] = gsub("^(t)","Time",col_names[i])
  col_names[i] = gsub("^(f)","Freq",col_names[i])
  col_names[i] = gsub("([Gg]ravity)","Gravity",col_names[i])
  col_names[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",col_names[i])
  col_names[i] = gsub("[Gg]yro","Gyro",col_names[i])
  col_names[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",col_names[i])
};

#Reassign cleansed variable names to dataset
colnames(all_dataset) = col_names;

##Section 4
#Create a new table excluding the activityType column
all_dataset_exc_activityType  = all_dataset[,names(all_dataset) != 'activityType'];

#Summarize the dataset to include the average of each variable grouped by activity and subject
tidy_dataset = aggregate(all_dataset_exc_activityType[,names(all_dataset_exc_activityType) != c('activityId','subjectId')],by=list(activityId=all_dataset_exc_activityType$activityId,subjectId = all_dataset_exc_activityType$subjectId),mean);

#Merge the tidy dataset with activity to include the acitvity names
tidy_dataset = merge(tidy_dataset,activity,by='activityId',all.x=TRUE);

##Section 5
# Export the tidyData set 
write.table(tidy_dataset, 'UCI HAR Dataset/tidy_dataset.txt',row.names=TRUE,sep='\t');
