# TODO:

# Importing libraries
library(ggplot2)
library(data.table)
library(data.frame)

# Static variables
# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/
placementPath <- "locationAnswers.csv" # CSV-path for location data
locDataLength <- 4 # Amount of columns
surveyPath <- "surveyAnswers.csv" # CSV-path for survey data
surveryQuestions <- 8 # Amount of questions in the survey
guardians <- c("Perma", "Meta") # Guardian names

########## Get survey data ##########

surveyData <- read.csv(surveyPath, header = FALSE) # Read data from file
surveyData <- t(surveyData) # Transpose data
guardianOrder <- surveyData[c(1,12),] # Get activated guardian
vrExperience <- surveyData[3,] # Get VR experience
surveyData <- surveyData[-c(1, 2, 3, 12, 13, 22, 23, 24),] # Remove questions from survey

# Separate survey questions
meanSurvey <- strtoi(list()) # Initialize empty list for mean matrix
for (i in 1:ncol(surveyData)) {
  tmp_participant <- matrix(unlist(surveyData[ , i]), nrow = surveryQuestions) # Cut to matrix
  tmp_surveyMean <- colMeans(tmp_participant) # Get mean of survey
  meanSurvey <- rbind(meanSurvey, tmp_surveyMean) # Append data to list
}

########## Get placement data ##########
placeData <- read.csv(placementPath, header = FALSE) # Read data from file
placeData <- t(placeData) # Transpose data

separatedList <- list() # Initialize empty list for separated matrices
IOM <- strtoi(list()) # Initialize empty list for mean matrix

for (i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow = locDataLength) # Cut to matrix
  rownames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  tmp_participant <- data.table(tmp_participant) # Convert to data.table
  tmp_participant <- na.omit(tmp_participant) # Remove NaN data values

  # Calculate the C-value for each row
  tmp_participant <- transform(
    tmp_participant, # Chose participant
    C = (sqrt(X*X + Z*Z) * W)) # Calculate C-value

  # Normalize each C-value depending on participant
  minC <- min(tmp_participant$C) # Get minimum value of C
  maxC <- max(tmp_participant$C) # Get maximum value of C
  tmp_participant$C <- t((tmp_participant$C - minC) / (maxC - minC)) # Normalize

  # Pack data for each participant
  tmp_participantId <- floor((i + 1) / 2)
  tmp_guardianId <- guardianOrder[i] # Un-/even participant
  tmp_locationCMean <- round(mean(data.table(tmp_participant)$C), 3) # C location mean
  tmp_surveyMean <- round(meanSurvey[i], 3) # Survey mean
  tmp_vrExperience <- vrExperience[tmp_participantId] # VR experience

  trail <- c(tmp_participantId, tmp_locationCMean, tmp_surveyMean, tmp_guardianId) # Construct package

  # Append C-mean and survey mean into a matrix
  IOM <- rbind(IOM, trail) # Append data package
  separatedList[[i]] <- data.table(tmp_participant) # Convert to data frame
}
colnames(IOM) <- c("Participant", "Movement", "Immersion", "Guardian") # Column names
IOM <- data.frame(IOM) # Convert to data.frame
IOM$Guardian <- as.factor(IOM$Guardian) # Integer Guardian-value

# Unlist each participant
IOM2 <- strtoi(list()) # Make list for updated IOM
for (i in seq(1, ncol(IOM)/2)) {
  tmp_participant_data <- subset(IOM, Participant == i, select = c(Movement, Immersion, Guardian)) # Select data sets from each participant
  tmp_participant_data <- unlist(tmp_participant_data) # Unlist participant data
  IOM2 <- rbind(IOM2, c(tmp_participant_data, vrExperience[i])) # Append data package
}
colnames(IOM2) <- c(colnames(IOM2)[-7], "Experience") # Add "Experience" to colname
IOM2 <- data.frame(IOM2) # Convert to data.frame
IOM2$Guardian1 <- as.factor(IOM2$Guardian1) # Integer Guardian-value
IOM2$Guardian2 <- as.factor(IOM2$Guardian2) # Integer Guardian-value
IOM2$Experience <- as.factor(IOM2$Experience) # Integer Experience-value

# Get mean of each guardian Shape
guardianMeans  =  strtoi(list())
for (i in 1:length(guardians)) {
  guardianData <- subset(IOM, Guardian == i, select = c(Movement, Immersion)) # Get data set from each guardian
  guardianMean <- colMeans(guardianData) # Get mean of each column
  guardianMeans <- rbind(guardianMeans, c(guardianMean, i)) # Append data package
}
guardianMeans <- data.frame(guardianMeans) # Convert to data.frame
colnames(guardianMeans) <- c("Movement", "Immersion", "Guardian") # Add "Guardian" to colnames
rownames(guardianMeans) <- guardians # Update guardian names as rows
guardianMeans$Guardian <- as.factor(guardianMeans$Guardian) # Integer Guardian-value

########## Show data ##########

# http://www.sthda.com/english/wiki/ggplot2-point-shapes
# https://stackoverflow.com/questions/58380045/plotting-lines-between-two-points-in-ggplot2

plot <- ggplot() +

  geom_curve(data = IOM2, aes(x = Movement1, y = Immersion1, xend = Movement2, yend = Immersion2),
             size = .5, color = "grey", curvature = -.2) +
  geom_point(data = IOM2, aes(x = Movement1, y = Immersion1, fill = Guardian1, shape = Experience), size = 5, pch = 21) +
  geom_point(data = IOM2, aes(x = Movement2, y = Immersion2, color = Guardian2), size = 5, pch = 16) +
  geom_point(data = guardianMeans, aes(x = Movement, y = Immersion, color = Guardian), size = 5, pch = 4) +

  scale_fill_manual(values = c('#D0312D','#1AA7EC'), guide = "none") +
  scale_color_manual(
    name = "Guardian",
    values = c('#D0312D','#1AA7EC'),
    labels = guardians) +
  scale_shape_manual(
    values = c(15, 16, 17, 18),
    labels = c("0", "1-5", "5-15", "15+")) +

  scale_y_continuous(
    breaks = seq(0, 7, by = 1),
    limits = c(1, 7)) +
  scale_x_continuous(
    breaks = seq(0, 1, by = .1),
    limits = c(0, 1)) +

  xlab("Movement") +
  ylab("Immersion") +

  theme(
    legend.position = c(.95, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(6, 6, 6, 6),

    legend.title  =  element_text(face = "bold"),
    legend.text = element_text(size = 10),
    legend.background = element_rect(
      size = 0.5, linetype = "solid",
      color = "grey"))

plot

ggsave(plot, height = 10, width = 10, filename = "IOM.png") # Save graph as PNG
