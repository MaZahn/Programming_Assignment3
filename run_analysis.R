setwd("ProgrammingAssignment_Week4/UCI HAR Dataset/")

######################################################################################################
######################################################################################################
###  READ THE DATA
######################################################################################################
######################################################################################################

# read features and activities: 
features      <- read.table("features.txt", header = FALSE)
activities    <- read.table("activity_labels.txt" )

# read train set, activity labels train, subjects train
X_train       <- read.table("train/X_train.txt", header = FALSE)
y_train       <- read.csv("train/y_train.txt", header = FALSE)
subject_train <- read.csv("train/subject_train.txt", header = FALSE)

# read test set, activity labels test, subjects test
X_test        <- read.table("test/X_test.txt", header = FALSE)
y_test        <- read.csv("test/y_test.txt", header = FALSE)
subject_test  <- read.csv("test/subject_test.txt", header = FALSE)


######################################################################################################
######################################################################################################
#### ASSIGNMENT 1   
#### MERGE THE DATA INTO ONE DATA SET
######################################################################################################
######################################################################################################
# first merge train and test data, respectively

#####################
# create arbitrary names for the subjects
personNames        <- data.frame(1:30,sort(c("Peter","Richard","Kevin","Lisa","Erik","Linda","Clara","Lizzie",
                                             "Beate","Viola","Thomas","Hans","Corinna","Ben","Frank","Tom","Eva",
                                             "Anna","Michael","Matt","Bart","Donald","Amily","Bill","Andy","Mel",
                                             "Britney","Louis","Simon","Jan")))
names(personNames) <-  c("V1","subjectName")

#####################
# merge the train data
tmp_subjects       <- merge(subject_train,personNames)
names(tmp_subjects)<- c("subjectlabel","subjectname")

names(X_train)      <- as.character(features[[2]])
tmp_merged         <- merge(y_train, activities)
names(tmp_merged)  <- c("activitylabel","activityname")

train               <- cbind(tmp_subjects,tmp_merged,X_train)
dim(train)
# clean up RAM
remove(tmp_merged,tmp_subjects,X_train,y_train,subject_train)


#####################
# merge the test data
tmp_subjects       <- merge(subject_test,personNames)
names(tmp_subjects)<- c("subjectlabel","subjectname")

names(X_test)      <- as.character(features[[2]])
tmp_merged         <- merge(y_test, activities)
names(tmp_merged)  <- c("activitylabel","activityname")

test               <- cbind(tmp_subjects,tmp_merged,X_test)

# clean up RAM
remove(tmp_merged,tmp_subjects,X_test,y_test,subject_test)
remove(activities,features,personNames)

data               <- rbind(train,test)
remove(test,train)


######################################################################################################
######################################################################################################
#### ASSIGNMENT 2   
#### EXTRACT MEAN AND STANDARD DEVIATION MEASURES ONLY
######################################################################################################
######################################################################################################

# grep variabels that contain the string mean, Mean or std in their names
tmp                <- grep("[M,m]ean|std",names(data) ) 
data               <- data[,c(2,4,tmp)]

remove(tmp)
######################################################################################################
######################################################################################################
#### ASSIGNMENT 3
#### USE DESCRIPTIVE ACTIVITY NAMES
######################################################################################################
######################################################################################################

# change activity names to lowercase
data$activityname <- tolower(data$activityname)


######################################################################################################
######################################################################################################
#### ASSIGNMENT 4
#### USE DESCRIPTIVE VARIABLE NAMES
######################################################################################################
######################################################################################################

listofnames <- names(data)

# assume, name element are separated by "-" sign
# change their order, delete brackets 
for (i in 3:length(listofnames)) {
        # count number of "-" signs in column name
        n <- sum(unlist(strsplit(listofnames[[i]], "")) == "-") 
        
        if(n==2){
                nm               <- strsplit(listofnames[[i]],"-")
                listofnames[[i]] <- paste0(sub("\\(\\)","",nm[[1]][2]),tolower(nm[[1]][1]),"into",nm[[1]][3],"direction")
        }else if(n==1){
                nm               <- strsplit(listofnames[[i]],"-")
                listofnames[[i]] <- paste0(sub("\\(\\)","",nm[[1]][2]),tolower(nm[[1]][1]))
        }else{
                nm               <- strsplit(listofnames[[i]],"\\(|,")
                listofnames[[i]] <- paste0(nm[[1]][1],nm[[1]][2],sub("\\)","",nm[[1]][3]))
        }       
        remove(nm)
}
names(data) <-listofnames
remove(i,n, listofnames)


######################################################################################################
######################################################################################################
#### ASSIGNMENT 5
#### CREATE VARIABLE MEANS PER  ACTIVITY AND SUBJECT 
######################################################################################################
######################################################################################################

library(reshape2)
# use melt and dcast to create variable means per per subject and activity
dataMelt    <- melt(data, id.vars = c("subjectname","activityname")) 
meanData    <- dcast(dataMelt, subjectname + activityname ~ variable, mean  )

# write data
write.table(file="ProgrammingAssignment_Week4.txt", meanData, row.name=FALSE)
remove(dataMelt,meanData)


