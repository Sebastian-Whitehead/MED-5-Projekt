# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/

library(ggplot2)

placementPath = "placement.csv"
surveyPath = "survey.csv"
rowLength = 4

###############################################################

########## Get survey data ##########

surveyData <- read.csv(surveyPath, header=FALSE) # Read data from file
surveyData <- t(surveyData) # Transpose data
surveyMean = colMeans(surveyData)

########## Get placement data ##########

placeData <- read.csv(placementPath, header=FALSE) # Read data from file
placeData <- t(placeData) # Transpose data

separatedList = list() # Initialize empty list for separated matrices
meanLocation = list()
for(i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow=rowLength) # Cut to matrix
  rownames(tmp_participant) <- c("x", "y", "z", "w") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  # tmp_participant = subset(tmp_participant, select=-c(w)) # Remove all w-values
  # meanLocation[[i]] = mean(data.table(tmp_participant)$w)
  tmp_mean <- mean(data.table(tmp_participant)$w)
  meanLocation <- rbind(meanLocation, c(tmp_mean, surveyMean[i]))
  separatedList[[i]] <- data.table(tmp_participant) # Convert to data frame
}

separatedList

colnames(meanLocation) <- c("x", "y") # Column names
meanLocation

# separatedList
# separatedList[1]
# data.frame(separatedList[1])$w
# c(meanLocation)
#
# # Get mean location
#
# # Get mean of all w-values in one participant
# mean(data.frame(separatedList[1])$w)
#
# mean

########## Show data ##########

ggplot(data=data.frame(separatedList[2]), aes(x=x, y=y, size=z)) + geom_point()

ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
ggplot(meanLocation, aes(x, y)) + geom_point()

# ggplot(data=data.frame(meanLocation), aes(x=x, y=y)) + geom_point() + scale_y_continuous(limits = c(0, 40))
