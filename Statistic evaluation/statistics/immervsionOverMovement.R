# http://www.sthda.com/english/wiki/ggplot2-point-shapes
# https://stackoverflow.com/questions/58380045/plotting-lines-between-two-points-in-ggplot2
# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/
# https://stackoverflow.com/questions/46068074/double-box-plots-in-ggplot2

# Importing libraries
library(ggplot2)
library(data.table)
library(data.frame)

########## Static variables ##########
placementPath <- "oneLineLocations_non-normalized2.csv" # CSV-path for location data
locDataLength <- 4                                      # Amount of columns
surveyPath <- "surveyAnswers_sorted_inverted.csv"       # CSV-path for survey data
surveryQuestions <- 8                                   # Amount of questions in the survey
guardians <- c("Perma", "Meta")                         # Guardian names
colors <- c('#D0312D', '#1AA7EC')                       # Colors used in plot for guardian
invertSurvey <- c(0, 0, 1, 1, 1, 0, 0, 0)               # Survey inversion list to make invert score rating
dataFrameNames <- c("Participant", "Confidence", "Immersion", "Speed", "Time", "Guardian", "Data")

########## Get survey data ##########
surveyData <- read.csv(surveyPath, header = FALSE)                    # Read data from file
guardianOrder <- t(surveyData[, c(1, 12)])                            # Get activated guardian
vrExperience <- surveyData[, 3]                                       # Get VR experience
surveyDataImmersion <- surveyData[, -c(1, 2, 3, 12, 13, 22, 23, 24)]  # Remove questions from survey
UXsurveyData <- surveyData[, c(22, 23, 24)]                           # Remove questions from survey
colnames(UXsurveyData) <- c("Usefull", "Helpfull", "Comfortable")     # Name UX survey matrix

# Invert each survey question and get the mean
meanSurvey <- strtoi(list()) # Initialize empty list for mean matrix
for (i in 1:nrow(surveyDataImmersion)) {
  tmp_participant_survey <- matrix(unlist(surveyDataImmersion[i,]), nrow = surveryQuestions) # Cut to matrix
  tmp_inverted_survey <- abs(tmp_participant_survey - replicate(2, matrix(invertSurvey)[,1]) * 7) # Invert survey
  tmp_surveyMean <- colMeans(tmp_inverted_survey) # Get mean of survey
  meanSurvey <- rbind(meanSurvey, tmp_surveyMean) # Append data to list
}

########## Get placement data ##########
fileIn <- file(placementPath, open="rb", encoding="UTF-8")  # Read data from file
lines <- readLines(fileIn, n = 1000, warn = TRUE)           # Read each line into a list

# List each trial
IOM <- strtoi(list()) # Initialize empty list for mean matrix
for (i in 1:length(lines)) {

  line <- gsub(" ", "", lines[i], fixed = TRUE)                                 # Remove whitespace
  line <- strsplit(line, ",")                                                   # Split string at ","/comma
  tmp_participant <- data.table(t(matrix(unlist(line), nrow = locDataLength)))  # Cut data string
  colnames(tmp_participant) <- c("X", "Y", "Z", "W")                            # Column names
  tmp_participant <- mapply(tmp_participant, FUN=as.numeric)                    # Make matrix numeric
  tmp_participant <- na.omit(tmp_participant)                                   # Remove NaN data values
  tmp_participant <- data.table(tmp_participant)                                # Remake data.table matrix

  # # Calculate the C-value for each row
  tmp_participant <- transform(
    tmp_participant, # Chose participant
    C = (sqrt(X*X + Z*Z) * W)) # Calculate C-value

  # Normalize each C-value depending on participant
  # minC <- min(tmp_participant$C) # Get minimum value of C
  # maxC <- max(tmp_participant$C) # Get maximum value of C
  # tmp_participant$C <- t((tmp_participant$C - minC) / (maxC - minC)) # Normalize

  # Pack data for each participant
  tmp_participantId <- floor((i + 1) / 2)                           # Participant id number
  tmp_guardianId <- guardianOrder[i]                                # Un-/even participant
  tmp_locationCMean <- round(mean(tmp_participant$C), 3)            # Calculate "C"onfidence score mean
  tmp_locationSpeedMean <- round(mean(abs(tmp_participant$W)), 3)   # Calculate "Speed" mean
  tmp_surveyMean <- round(meanSurvey[i], 3)                         # Get specific survey mean, immersion from before
  tmp_vrExperience <- vrExperience[tmp_participantId]               # Previous VR experience
  tmp_firstTrial <- i %% 2                                          # Trial is first of participant
  tmp_time <- length(tmp_participant$C)                             # Get seconds taken for trial

  # Construct package
  Trial <- c(
    tmp_participantId,
    tmp_locationCMean,
    tmp_surveyMean,
    tmp_locationSpeedMean,
    tmp_time,
    tmp_guardianId,
    tmp_firstTrial
  )
  IOM <- rbind(IOM, Trial) # Append data package
}
colnames(IOM) <- dataFrameNames # Column names
IOM <- data.frame(IOM) # Convert to data.frame

# Unlist each participant
participantData <- strtoi(list()) # Make list for updated IOM
for (i in seq(1, nrow(IOM)/2)) {
  tmp_participant_data <- subset(IOM, Participant == i, select = c(Confidence, Immersion, Speed, Guardian)) # Select data sets from each participant
  tmp_participant_data <- unlist(tmp_participant_data) # Unlist participant data

  #
  if (tmp_participant_data["Guardian1"] == 1 && tmp_participant_data["Guardian2"] == 2) {
    DeltaConfidence = abs(tmp_participant_data["Confidence1"] / tmp_participant_data["Confidence2"])
    DeltaSpeed = abs(tmp_participant_data["Speed1"] / tmp_participant_data["Speed2"])
  } else if (tmp_participant_data["Guardian1"] == 2 && tmp_participant_data["Guardian2"] == 1){
    DeltaConfidence = abs(tmp_participant_data["Confidence2"] / tmp_participant_data["Confidence1"])
    DeltaSpeed = abs(tmp_participant_data["Speed2"] / tmp_participant_data["Speed1"])
  }

  tmp_package <- c(tmp_participant_data, vrExperience[i], DeltaConfidence, DeltaSpeed)
  participantData <- rbind(participantData, tmp_package) # Append data package
}
participantData <- data.frame(participantData) # Convert to data.frame
colnames(participantData) <- c(
  "Confidence1", "Confidence2", "Immersion1", "Immersion2", "Speed1", "Speed2",
  "Guaridan1", "Guardian2", "Experience", "DeltaConfidence", "DeltaSpeed")

# Get mean of each guardian Shape
guardianMeans <- strtoi(list())
for (i in 1:length(guardians)) {
  guardianData <- subset(IOM, Guardian == i, select = c(Confidence, Immersion, Speed, Time)) # Get data set from each guardian
  guardianMean <- colMeans(guardianData) # Get mean of each column
  guardianPackage <- c(0, guardianMean, i, 2) # Package data
  guardianMeans <- rbind(guardianMeans, guardianPackage) # Append data package
}
guardianMeans <- data.frame(guardianMeans) # Convert to data.frame
colnames(guardianMeans) <- dataFrameNames

# Make data for 2D box-plot
boxData <- strtoi(list())
for (i in 1:length(guardians)) {
  guardianBoxData <- subset(IOM, Guardian == i, select = c(Confidence, Immersion))
  bp <- boxplot(guardianBoxData)
  data <- c(bp$stats[, 1], bp$stats[, 2])
  boxData <- rbind(boxData, c(data, i))
  print(bp$out)
}
boxData <- data.frame(boxData)
colnames(boxData) <- c("x.min", "x.lower", "x.middle", "x.upper", "x.max",
                       "y.min", "y.lower", "y.middle", "y.upper", "y.max", "Guardian")

###############################
########## Show data ##########
###############################

ggplot() + ggtitle("Confidence over immersion plot") +

  # Make lines between participant points
  geom_segment(data = participantData,
               aes(x = Confidence1, y = Immersion1, xend = Confidence2, yend = Immersion2),
               size = .5, color = "grey", show.legend = TRUE) +

  # Make points and mean
  geom_point(data = IOM,
             aes(x = Confidence, y = Immersion,
                 color = factor(Guardian), fill = factor(Guardian),
                 shape = factor(Data)), size = 2, stroke = 1.5, alpha = .7) +

  # Make first Trial of each participant points
  geom_point(data = participantData,
             aes(x = Confidence1, y = Immersion1),
             size = 2, pch = 21, alpha = .7) +

  # Make first Trial of each participant points
  geom_point(data = guardianMeans,
             aes(x = Confidence, y = Immersion, color=factor(Guardian)),
             size = 5, pch = 4, alpha = 1, stroke = 2) +

  # Update visuals and legend of properties
  scale_fill_manual(
    values = colors,
    guide = "none") +
  scale_color_manual(
    name = "Guardian",
    values = colors,
    labels = guardians) +
  scale_shape_manual(
    name = "Data type",
    values = c(16, 21, 4),
    labels = c("Trial", "First", "Mean")) +
  scale_linetype_manual(
    name = "Participant",
    values = c("Connection" = 1)) +

  # Update x- and y-axis properties
  xlab("Confidence [μ(|x, y| * w])") + ylab("Immersion [μ]") +
  scale_x_continuous(
    breaks = seq(.1, .6, by = .05),
    limits = c(.1, .6)) +
  scale_y_continuous(
    breaks = seq(1, 7, by = .5),
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

############################################

# 2D box plot
ggplot(data=boxData) + ggtitle("Confidence over immersion box-plot") +

  xlab("Confidence [μ(|x,y| * w])") + ylab("Immersion [μ]") +

  scale_x_continuous(
    breaks = seq(.1, .6, by = .05),
    limits = c(.1, .6)) +
  scale_y_continuous(
    breaks = seq(1, 7, by = 1),
    limits = c(1, 7)) +

  # 2D box defined by the Q1 & Q3 values in each dimension, with outline
  geom_rect(aes(
    xmin = x.lower, xmax = x.upper,
    ymin = y.lower, ymax = y.upper,
    fill = factor(Guardian)), color = "black", alpha = .5) +

  # Whiskers for x-axis dimension with ends
  geom_segment(aes(x = x.min, y = y.middle, xend = x.max, yend = y.middle, color = factor(Guardian))) + # whiskers
  geom_segment(aes(x = x.min, y = y.lower, xend = x.min, yend = y.upper, color = factor(Guardian))) + # lower end
  geom_segment(aes(x = x.max, y = y.lower, xend = x.max, yend = y.upper, color = factor(Guardian))) + # upper end

  # Whiskers for y-axis dimension with ends
  geom_segment(aes(x = x.middle, y = y.min, xend = x.middle, yend = y.max, color = factor(Guardian))) + # whiskers
  geom_segment(aes(x = x.lower, y = y.min, xend = x.upper, yend = y.min, color = factor(Guardian))) + # lower end
  geom_segment(aes(x = x.lower, y = y.max, xend = x.upper, yend = y.max, color = factor(Guardian))) + # upper end

  geom_point(x = 0.501, y = boxData$y.middle[1], color = colors[1]) +

  # Update visuals and legend of properties
  scale_fill_manual(
    name = "Guardian",
    values = colors,
    labels = guardians) +
  scale_color_manual(
    guide = "none",
    values = colors) +

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

# Relative average speed by VR experience
ggplot(participantData, aes(x = DeltaSpeed, y = factor(Experience))) + ggtitle("Relative average speed by VR experience") +
  geom_boxplot() +
  geom_vline(aes(xintercept = 1), color = "red", linetype = "dashed", size = .8) +
  ylab("Virtual Reality Experience [sessions]") + xlab("Relative Speed [Pμ/Mμ]") +
  scale_y_discrete(labels=c("1-5", "5-14", "15+"))

# Relative confidence by VR experience
ggplot(participantData, aes(x = DeltaConfidence, y = factor(Experience))) + ggtitle("Relative confidence by VR experience") +
  geom_boxplot() +
  geom_vline(aes(xintercept = 1), color = "red", linetype = "dashed", size = .5) +
  ylab("Virtual Reality Experience [sessions]") + xlab("Relative confidence [Pμ/Mμ]") +
  scale_y_discrete(labels=c("1-5", "5-14", "15+"))

# Time taken completing task
ggplot(IOM, aes(x = Time, y = factor(Guardian))) + ggtitle("Time taken completing task") +
  geom_boxplot() +
  ylab("Guardian") + xlab("Time [s]") +
  scale_y_discrete(labels=c("Perma", "Meta"))

# Absolute relative confidence score
ggplot(participantData, aes(x = DeltaConfidence)) + ggtitle("Absolute relative confidence") +

  geom_histogram(color = "black", fill = "white", bins = 20) +
  geom_density(alpha = .2, fill = "black") +
  geom_boxplot(aes(y = -.5)) +
  geom_vline(aes(xintercept = 1), color = "red", linetype = "dashed", size = .9) +

  scale_x_continuous(breaks = seq(-2, 6, by = .1)) +

  ylab("Frequency") + xlab("Absolute relative confidence [Pμ/Mμ]")

# Relative confidence
ggplot(participantData, aes(x = DeltaConfidence, y = "")) + ggtitle("Relative confidence score") +
  geom_boxplot() +
  geom_vline(aes(xintercept = 1), color = "red", linetype = "dashed", size = .8) +
  ylab("") + xlab("Relative confidence [Pμ/Mμ]") +
  scale_y_discrete(labels=c(""))

# Absolute relative average speed
ggplot(participantData, aes(x = DeltaSpeed)) + ggtitle("Absolute relative average speed") +

  geom_histogram(color = "black", fill = "white", bins = 20) +
  geom_density(alpha = .2, fill = "black") +
  geom_boxplot(aes(y = -.5)) +
  geom_vline(aes(xintercept = 1), color = "red", linetype = "dashed", size = .9) +

  scale_x_continuous(breaks = seq(-2, 6, by = .05)) +

  ylab("Frequency") + xlab("Absolute relative confidence [Pμ/Mμ]")

# Relative average speed
ggplot(participantData, aes(x = DeltaSpeed, y = "")) + ggtitle("Relative average speed") +
  geom_boxplot() +
  geom_vline(aes(xintercept = 1), color = "red", linetype = "dashed", size = .8) +
  ylab("") + xlab("Relative speed [Pμ/Mμ]") +
  scale_y_discrete(labels=c(""))

# Plot user experience from survey
par(mfrow=c(1, 3)) # Enable 3 plots along x-axis
hist(UXsurveyData$Usefull, breaks = 5, main = "Usefull", ylim = c(0, 14), xlab = "Perma                                         Meta")
hist(UXsurveyData$Helpfull, breaks = 5, main = "Helpfull", ylim = c(0, 14), xlab = "Perma                                         Meta")
hist(UXsurveyData$Comfortable, breaks = 5, main = "Comfortable", ylim = c(0, 14), xlab = "Perma                                         Meta")
par(mfrow=c(1, 1)) # Disable multiple plots
