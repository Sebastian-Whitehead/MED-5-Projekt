# http://www.sthda.com/english/wiki/ggplot2-point-shapes
# https://stackoverflow.com/questions/58380045/plotting-lines-between-two-points-in-ggplot2
# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/

# TODO:

# Importing libraries
library(ggplot2)
library(data.table)
library(data.frame)

# Static variables
placementPath <- "oneLineLocations.csv" # CSV-path for location data
locDataLength <- 4 # Amount of columns
surveyPath <- "surveyAnswers_sorted_inverted.csv" # CSV-path for survey data
surveryQuestions <- 8 # Amount of questions in the survey
guardians <- c("Perma", "Meta") # Guardian names
colors <- c('#D0312D', '#1AA7EC') # Colors used in plot for guardian
invertSurvey <- c(0, 0, 1, 1, 1, 0, 0, 0) # Survey inversion list to make invert score rating
dataFrameNames <- c("Participant", "Movement", "Immersion", "Guardian", "Data")

########## Get survey data ##########
surveyData <- read.csv(surveyPath, header = FALSE) # Read data from file
surveyData <- t(surveyData) # Transpose data
guardianOrder <- surveyData[c(1,12),] # Get activated guardian
vrExperience <- surveyData[3,] # Get VR experience
surveyData <- surveyData[-c(1, 2, 3, 12, 13, 22, 23, 24),] # Remove questions from survey

# Separate survey questions
meanSurvey <- strtoi(list()) # Initialize empty list for mean matrix
for (i in 1:ncol(surveyData)) {
  tmp_participant_survey <- matrix(unlist(surveyData[ , i]), nrow = surveryQuestions) # Cut to matrix
  tmp_inverted_survey <- abs(tmp_participant_survey - replicate(2, matrix(invertSurvey)[,1]) * 7) # Invert survey
  tmp_surveyMean <- colMeans(tmp_inverted_survey) # Get mean of survey
  meanSurvey <- rbind(meanSurvey, tmp_surveyMean) # Append data to list
}

########## Get placement data ##########
fileIn=file(placementPath, open="rb", encoding="UTF-8") # Read data from file
lines = readLines(fileIn, n = 1000, warn = TRUE) # Read each line into a list

# List each trial
IOM <- strtoi(list()) # Initialize empty list for mean matrix
for (i in 1:length(lines)) {

  line <- gsub(" ", "", lines[i], fixed = TRUE) # Remove whitespace
  line <- strsplit(line, ",") # Split string at ","/comma
  tmp_participant <- data.table(t(matrix(unlist(line), nrow = 4)))
  colnames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- na.omit(tmp_participant) # Remove NaN data values
  tmp_participant <- mapply(tmp_participant, FUN=as.numeric) # Make matrix numeric
  tmp_participant <- data.table(tmp_participant) # Remake data.table matrix

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
  tmp_locationCMean <- round(mean(data.table(tmp_participant)$C), 3) # Calculate "C" location mean
  tmp_surveyMean <- round(meanSurvey[i], 3) # Survey mean
  tmp_vrExperience <- vrExperience[tmp_participantId] # VR experience
  tmp_firstTrial <- i %% 2 # Trail is first of participant

  trail <- c(tmp_participantId, tmp_locationCMean, tmp_surveyMean, tmp_guardianId, tmp_firstTrial) # Construct package
  IOM <- rbind(IOM, trail) # Append data package
}
colnames(IOM) <- dataFrameNames # Column names
IOM <- data.frame(IOM) # Convert to data.frame

# Unlist each participant
participantData <- strtoi(list()) # Make list for updated IOM
for (i in seq(1, nrow(IOM)/2)) {
  tmp_participant_data <- subset(IOM, Participant == i, select = c(Movement, Immersion, Guardian)) # Select data sets from each participant
  tmp_participant_data <- unlist(tmp_participant_data) # Unlist participant data
  participantData <- rbind(participantData, c(tmp_participant_data, vrExperience[i])) # Append data package
}
participantData <- data.frame(participantData) # Convert to data.frame
colnames(participantData) <- c(
  "Movement1", "Movement2",
  "Immersion1", "Immersion2",
  "Guaridan1", "Guardian2", "Experience")

# Get mean of each guardian Shape
guardianMeans  =  strtoi(list())
for (i in 1:length(guardians)) {
  guardianData <- subset(IOM, Guardian == i, select = c(Movement, Immersion)) # Get data set from each guardian

  guardianData <- mapply(guardianData, FUN=as.numeric)
  guardianMean <- colMeans(guardianData) # Get mean of each column
  guardianPackage <- c(0, guardianMean, i, 2)
  guardianMeans <- rbind(guardianMeans, guardianPackage) # Append data package
  IOM <- rbind(IOM, guardianPackage) # Append data package
}
guardianMeans <- data.frame(guardianMeans) # Convert to data.frame
colnames(guardianMeans) <- dataFrameNames

########## Show data ##########
plot <- ggplot() +

  # Make lines between participant points
  geom_segment(data = participantData,
               aes(x = Movement1, y = Immersion1, xend = Movement2, yend = Immersion2),
               size = .5, color = "grey", show.legend = TRUE) +

  # Make points and mean
  geom_point(data = IOM,
             aes(x = Movement, y = Immersion,
                 color = factor(Guardian), fill = factor(Guardian),
                 shape = factor(Data)), size = 2, stroke = 1.5, alpha = .7) +

  # Make first trail of each participant points
  geom_point(data = participantData,
             aes(x = Movement1, y = Immersion1),
             size = 2, pch = 21, alpha = .7) +

  # Make first trail of each participant points
  geom_point(data = guardianMeans,
             aes(x = Movement, y = Immersion, color=factor(Guardian)),
             size = 5, pch = 4, alpha = 1, stroke = 2) +

  # Update visuals and legend of properties
  scale_fill_manual(
    values = colors,
    guide = "none") +
  scale_color_manual(
    name = "Guardian type",
    values = colors,
    labels = guardians) +
  scale_shape_manual(
    name = "Data type",
    values = c(16, 21, 4),
    labels = c("Trail", "First", "Mean")) +
  scale_linetype_manual(
    name = "Participant",
    values = c("Connection" = 1)) +

  # Update x- and y-axis properties
  xlab("Movement") +
  ylab("Immersion") +
  scale_x_continuous(
    breaks = seq(0, 1, by = .1),
    limits = c(0, 1)) +
  scale_y_continuous(
    breaks = seq(0, 7, by = 1),
    limits = c(1, 7)) +

  # Update legend properties
  theme(
    legend.position = c(.95, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(6, 6, 6, 6),

    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    legend.background = element_rect(
      size = 0.5, linetype = "solid",
      color = "grey"))
plot

ggsave(plot, height = 10, width = 10, filename = "IOM.png") # Save graph as PNG

IOM
participantData
guardianMeans
