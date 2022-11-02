# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/

library(ggplot2)

placementPath = "placement.csv"
rowLength = 4

###############################################################

placeData <- read.csv(placementPath, header=FALSE) # Read data from file
placeData <- t(placeData) # Transpose data

separatedList = list() # Initialize empty list for separated matrices
for(i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow=rowLength) # Cut to matrix
  rownames(tmp_participant) <- c("x", "y", "z", "w") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  # Remove all w-values
  # tmp_participant = subset(tmp_participant, select=-c(w))
  separatedList[[i]] = data.frame(tmp_participant) # Convert to data frame
}

separatedList
separatedList[1]
data.frame(separatedList[1])$w

# Get mean of all w-values in one participant
mean(data.frame(separatedList[1])$w)

ggplot(data=data.frame(separatedList[2]), aes(x=x, y=y, size=z)) + geom_point()
