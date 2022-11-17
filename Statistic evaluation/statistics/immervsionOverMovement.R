# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/
# tmp_participant = subset(tmp_participant, select=-c(w)) # Remove all w-values

# TODO:
# - Change label names in legend
# - Normalize data

# Importing libraries
library(ggplot2)
library(data.table)

# Static variables
placementPath = "datatest.csv" # CSV-path for location data
locDataLength = 4 # Amount of columns
surveyPath = "surveyPilot.csv" # CSV-path for survey data
surveryQuestions = 8 # Amount of questions in the survey
guardians = c("Meta", "Perma") # Guardian names

########## Get survey data ##########

surveyData <- read.csv(surveyPath, header=FALSE) # Read data from file
surveyData <- t(surveyData) # Transpose data
surveyData <- surveyData[c(-1,-2,-3,-12,-13,-22,-23,-24),] # Remove questions from survey

# Separate survey questions
meanSurvey = strtoi(list()) # Initialize empty list for mean matrix
for (i in 1:ncol(surveyData)) {
  tmp_participant <- matrix(unlist(surveyData[ , i]), nrow=surveryQuestions) # Cut to matrix
  tmp_surveyMean = colMeans(tmp_participant) # Get mean of survey
  meanSurvey <- rbind(meanSurvey, tmp_surveyMean) # Append data to list
}

########## Get placement data ##########
placeData <- read.csv(placementPath, header=FALSE) # Read data from file
placeData <- t(placeData) # Transpose data

separatedList = list() # Initialize empty list for separated matrices
immersionOverMovement = strtoi(list()) # Initizlize empty list for mean matrix

for (i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow=locDataLength) # Cut to matrix
  rownames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  tmp_participant <- data.table(tmp_participant) # Convert to data.table
  tmp_participant <- na.omit(tmp_participant) # Remove NaN data values

  # Calculate the C-value for each row
  tmp_participant = transform(
    tmp_participant, # Chose participant
    C=(sqrt(X*X + Z*Z) * W)) # Calculate C-value

  # Normalize each C-value depending on participant
  minC = min(tmp_participant$C) # Get minimum value of C
  maxC = max(tmp_participant$C) # Get maximum value of C
  tmp_participant$C = t((tmp_participant$C - minC) / (maxC - minC)) # Normalize

  # Pack data for each participant
  tmp_guardianId = i %% 2 + 1 # Un-/even participant
  tmp_locationCMean = round(mean(data.table(tmp_participant)$C), 3) # C location mean
  tmp_surveyMean = round(meanSurvey[i], 3) # Survey mean
  trail = c(tmp_locationCMean, tmp_surveyMean, tmp_guardianId) # Construct package

  # Append C-mean and survey mean into a matrix
  immersionOverMovement <- rbind(immersionOverMovement, trail) # Append data package
  separatedList[[i]] <- data.table(tmp_participant) # Convert to data frame
}
colnames(immersionOverMovement) <- c("Movement", "Immersion", "Guardian") # Column names
immersionOverMovement <- data.frame(immersionOverMovement) # Convert to data.frame
immersionOverMovement$Guardian <- as.factor(immersionOverMovement$Guardian) # Integer Guardian-value

########## Show data ##########

plot <- ggplot(
  data=immersionOverMovement,
  aes(x=Movement, y=Immersion, color=Guardian)) +
  geom_point(size=5) +
  scale_y_continuous(
    breaks=seq(0, 7, by=1),
    limits=c(1, 7)) +
  scale_x_continuous(
    breaks=seq(0, 1, by=.1),
    limits=c(0, 1)) +
  theme(legend.position="top",
        legend.text=element_text(
          size=13),
        legend.background=element_rect(
          size=0.5, linetype="solid",
          color ="grey"))
  # labs(title = "#######",
  #      subtitle = "#######",
  #      caption = "#######")
plot

ggsave(plot, height=10, width=10, filename="immersionOverMovement.png") # Save graph as PNG
