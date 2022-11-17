# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/
# tmp_participant = subset(tmp_participant, select=-c(w)) # Remove all w-values

# TODO:
# - Change label names in legend
# - Normalize data
# - Set width and height to 1, 1

# Importing libraries
library(ggplot2)
library(data.table)

# Static variables
placementPath = "datatest.csv" # CSV-path for location data
rowLength = 4 # Amount of columns
surveyPath = "surveyPilot.csv" # CSV-path for survey data
guardians = c("Meta", "Perma") # Guardian names

########## Get survey data ##########

surveyData <- read.csv(surveyPath, header=FALSE) # Read data from file
surveyData <- t(surveyData) # Transpose data

surveyData <- surveyData[c(-1,-2,-3,-12,-13,-22,-23,-24),]
meanSurvey = strtoi(list()) # Initizlize empty list for mean matrix
for (i in 1:ncol(surveyData)) {
  tmp_participant <- matrix(unlist(surveyData[ , i]), nrow=8) # Cut to matrix
  meanSurvey <- rbind(meanSurvey, colMeans(tmp_participant))
}

########## Get placement data ##########
placeData <- read.csv(placementPath, header=FALSE) # Read data from file
placeData <- t(placeData) # Transpose data

separatedList = list() # Initialize empty list for separated matrices
meanLocation = strtoi(list()) # Initizlize empty list for mean matrix

for (i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow=rowLength) # Cut to matrix
  rownames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  tmp_participant <- data.table(tmp_participant)
  tmp_participant <- na.omit(tmp_participant)

  # Calculate the C-value for each row
  tmp_participant = transform(
    tmp_participant, # Chose participant
    C=(sqrt(X*X + Z*Z) * W)) # Calculate C-value

  # Normalize each C-value depending on participant
  minC = min(tmp_participant$C) # Get minimum value of C
  maxC = max(tmp_participant$C) # Get maximum value of C
  tmp_participant$C = t((tmp_participant$C - minC) / (maxC - minC))

  # Pack data for each participant
  tmp_guardianId = i %% 2 + 1 # Un-/even participant
  tmp_locationCMean = round(mean(data.table(tmp_participant)$C), 3) # C-mean
  tmp_surveyMean = round(meanSurvey[i], 3) # Survey mean
  trail = c(tmp_locationCMean, tmp_surveyMean, tmp_guardianId)

  # Append C-mean and survey mean into a matrix
  meanLocation <- rbind(meanLocation, trail)
  separatedList[[i]] <- data.table(tmp_participant) # Convert to data frame
}
colnames(meanLocation) <- c("Movement", "Immersion", "Guardian") # Column names
meanLocation <- data.frame(meanLocation)
meanLocation$Guardian <- as.factor(meanLocation$Guardian) # Integar Guardian-value

########## Show data ##########

plot <- ggplot(
  data=meanLocation,
  aes(x=Movement, y=Immersion, color=Guardian)) +
  geom_point(size=5) +
  theme(legend.position="top",
        legend.text=element_text(
          size=13),
        legend.background=element_rect(
          size=0.5, linetype="solid",
          color ="grey")) +
  ylim(0, 7)
  # labs(title = "#######",
  #      subtitle = "#######",
  #      caption = "#######")
plot

ggsave(plot, filename="immersionOverMovement.png") # Save graph as PNG
