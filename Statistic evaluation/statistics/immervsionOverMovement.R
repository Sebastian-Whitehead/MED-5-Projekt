# http://www.sthda.com/english/wiki/ggplot2-point-shapes
# https://stackoverflow.com/questions/58380045/plotting-lines-between-two-points-in-ggplot2
# https://www.geeksforgeeks.org/how-to-convert-csv-into-array-in-r/

# TODO:

# Importing libraries
library(ggplot2)
library(data.table)
library(data.frame)

# Static variables
placementPath <- "oneLineLocations_normalized.csv" # CSV-path for location data
locDataLength <- 4 # Amount of columns
surveyPath <- "surveyAnswers_sorted_inverted.csv" # CSV-path for survey data
surveryQuestions <- 8 # Amount of questions in the survey
guardians <- c("Perma", "Meta") # Guardian names
colors <- c('#D0312D', '#1AA7EC') # Colors used in plot for guardian
invertSurvey <- c(0, 0, 1, 1, 1, 0, 0, 0) # Survey inversion list to make invert score rating
dataFrameNames <- c("Participant", "Movement", "Immersion", "Time", "Guardian", "Data")

surveyData <- read.csv(surveyPath, header = FALSE) # Read data from file
surveyData <- t(surveyData)
surveyData <- surveyData[c(22, 23, 24),] # Remove questions from survey
surveyData <- t(surveyData)
colnames(surveyData) <- c("Usefull", "Helpfull", "Comfortable")
surveyData <- melt(data.table(surveyData))

# box = ggplot(surveyData, aes(x = value, y = variable, color = variable)) +
#   geom_boxplot() +
#   scale_color_manual(guide = "none", values = c(2,4,6)) +
#   ylab("") + xlab("Perma                                                                                                                                            Meta") +
#   ggtitle("Perma v. Meta user experience")

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
fileIn <- file(placementPath, open="rb", encoding="UTF-8") # Read data from file
lines <- readLines(fileIn, n = 1000, warn = TRUE) # Read each line into a list

# List each trial
IOM <- strtoi(list()) # Initialize empty list for mean matrix
for (i in 1:length(lines)) {

  line <- gsub(" ", "", lines[i], fixed = TRUE) # Remove whitespace
  line <- strsplit(line, ",") # Split string at ","/comma
  tmp_participant <- data.table(t(matrix(unlist(line), nrow = locDataLength)))
  colnames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- mapply(tmp_participant, FUN=as.numeric) # Make matrix numeric
  tmp_participant <- na.omit(tmp_participant) # Remove NaN data values
  tmp_participant <- data.table(tmp_participant) # Remake data.table matrix

  # # Calculate the C-value for each row
  tmp_participant <- transform(
    tmp_participant, # Chose participant
    C = (sqrt(X*X + Z*Z) * W)) # Calculate C-value

  # tmp_participant$C = abs(tmp_participant$W)

  # positiveW = data.table(subset(tmp_participant, W > 0, select = W))
  # positiveW <- mapply(positiveW, FUN=as.numeric) # Make matrix numeric

  # Normalize each C-value depending on participant
  # minC <- min(tmp_participant$C) # Get minimum value of C
  # maxC <- max(tmp_participant$C) # Get maximum value of C
  # tmp_participant$C <- t((tmp_participant$C - minC) / (maxC - minC)) # Normalize

  # Pack data for each participant
  tmp_participantId <- floor((i + 1) / 2)
  tmp_guardianId <- guardianOrder[i] # Un-/even participant
  tmp_locationCMean <- round(mean(tmp_participant$C), 3) # Calculate "C" location mean
  # tmp_locationCMean <- round(mean(positiveW), 3) # Calculate "C" location mean
  tmp_surveyMean <- round(meanSurvey[i], 3) # Survey mean
  tmp_vrExperience <- vrExperience[tmp_participantId] # VR experience
  tmp_firstTrial <- i %% 2 # Trial is first of participant
  tmp_time <- length(tmp_participant$C)

  Trial <- c(tmp_participantId, tmp_locationCMean, tmp_surveyMean, tmp_time, tmp_guardianId, tmp_firstTrial) # Construct package
  IOM <- rbind(IOM, Trial) # Append data package
}
colnames(IOM) <- dataFrameNames # Column names
IOM <- data.frame(IOM) # Convert to data.frame

# Unlist each participant
participantData <- strtoi(list()) # Make list for updated IOM
for (i in seq(1, nrow(IOM)/2)) {
  tmp_participant_data <- subset(IOM, Participant == i, select = c(Movement, Immersion, Guardian)) # Select data sets from each participant
  tmp_participant_data <- unlist(tmp_participant_data) # Unlist participant data

  if (tmp_participant_data["Guardian1"] == 1 && tmp_participant_data["Guardian2"] == 2) {
    Delta = tmp_participant_data["Movement1"] / tmp_participant_data["Movement2"]
  } else if (tmp_participant_data["Guardian1"] == 2 && tmp_participant_data["Guardian2"] == 1){
    Delta = tmp_participant_data["Movement2"] / tmp_participant_data["Movement1"]
  } else {
    print("ERROR")
  }

  participantData <- rbind(participantData, c(tmp_participant_data, vrExperience[i], Delta)) # Append data package
}
participantData <- data.frame(participantData) # Convert to data.frame
colnames(participantData) <- c(
  "Movement1", "Movement2",
  "Immersion1", "Immersion2",
  "Guaridan1", "Guardian2",
  "Experience", "Delta")

# Get mean of each guardian Shape
guardianMeans <- strtoi(list())
guardiansData <- strtoi(list())
for (i in 1:length(guardians)) {
  guardianData <- subset(IOM, Guardian == i, select = c(Movement, Immersion, Time)) # Get data set from each guardian

  guardianData <- mapply(guardianData, FUN=as.numeric)
  guardianMean <- colMeans(guardianData) # Get mean of each column
  guardianPackage <- c(0, guardianMean, i, 2)

  guardianMeans <- rbind(guardianMeans, guardianPackage) # Append data package
  IOM <- rbind(IOM, guardianPackage) # Append data package
}
guardianMeans <- data.frame(guardianMeans) # Convert to data.frame
guardiansData <- data.frame(guardiansData) # Convert to data.frame
colnames(guardianMeans) <- dataFrameNames

########## Show data ##########
plot <- ggplot() +

  ggtitle("Confidence over immersion points (Normalized)") +

  # Make lines between participant points
  geom_segment(data = participantData,
               aes(x = Movement1, y = Immersion1, xend = Movement2, yend = Immersion2),
               size = .5, color = "grey", show.legend = TRUE) +

  # Make points and mean
  geom_point(data = IOM,
             aes(x = Movement, y = Immersion,
                 color = factor(Guardian), fill = factor(Guardian),
                 shape = factor(Data)), size = 2, stroke = 1.5, alpha = .7) +

  # Make first Trial of each participant points
  geom_point(data = participantData,
             aes(x = Movement1, y = Immersion1),
             size = 2, pch = 21, alpha = .7) +

  # Make first Trial of each participant points
  geom_point(data = guardianMeans,
             aes(x = Movement, y = Immersion, color=factor(Guardian)),
             size = 5, pch = 4, alpha = 1, stroke = 2) +

  # Make zero line
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", alpha = .4) +
  geom_hline(yintercept = 4, linetype = "dashed", color = "black", alpha = .4) +

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
  xlab("Confidence [μ(|x,y| * w])") + ylab("Immersion [μ]") +
  scale_x_continuous(
    breaks = seq(-.5, .7, by = .1),
    limits = c(-.5, .7)) +
  scale_y_continuous(
    breaks = seq(1, 7, by = 1),
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

boxData <- strtoi(list())
for (i in 1:length(guardians)) {
  guardianBoxData <- subset(IOM, Guardian == i, select = c(Movement, Immersion))
  bp <- boxplot(guardianBoxData)
  data <- c(bp$stats[,1], bp$stats[,2])
  boxData <- rbind(boxData, c(data, i))
}
df <- data.frame(boxData)
colnames(df) <- c("x.min", "x.lower", "x.middle", "x.upper", "x.max", "y.min", "y.lower", "y.middle", "y.upper", "y.max", "Guardian")

# https://stackoverflow.com/questions/46068074/double-box-plots-in-ggplot2
box <- ggplot(data=df) +

  ggtitle("Weighted confidence over immersion boxplot (Normalized)") +

    scale_x_continuous(
      breaks = seq(-.1, 2.3, by = .25),
      limits = c(-.1, 2.3)) +
    scale_y_continuous(
      breaks = seq(1, 7, by = 1),
      limits = c(1, 7)) +

  xlab("Confidence [μ(|x,y| + w * 3.417])") + ylab("Immersion [μ]") +

  # 2D box defined by the Q1 & Q3 values in each dimension, with outline
  geom_rect(aes(
    xmin = x.lower, xmax = x.upper,
    ymin = y.lower, ymax = y.upper,
    fill = factor(Guardian)), color = "black", alpha = .5) +

  # whiskers for x-axis dimension with ends
  geom_segment(aes(x = x.min, y = y.middle, xend = x.max, yend = y.middle, color = factor(Guardian))) + #whiskers
  geom_segment(aes(x = x.min, y = y.lower, xend = x.min, yend = y.upper, color = factor(Guardian))) + #lower end
  geom_segment(aes(x = x.max, y = y.lower, xend = x.max, yend = y.upper, color = factor(Guardian))) + #upper end

  # whiskers for y-axis dimension with ends
  geom_segment(aes(x = x.middle, y = y.min, xend = x.middle, yend = y.max, color = factor(Guardian))) + #whiskers
  geom_segment(aes(x = x.lower, y = y.min, xend = x.upper, yend = y.min, color = factor(Guardian))) + #lower end
  geom_segment(aes(x = x.lower, y = y.max, xend = x.upper, yend = y.max, color = factor(Guardian))) + #upper end

  # outliers
  # geom_point(data = df.outliers, aes(x = x.outliers, y = y.middle), size = 3, shape = 1) + # x-direction
  # geom_point(data = df.outliers, aes(x = x.middle, y = y.outliers), size = 3, shape = 1) + # y-direction


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
      color = "grey")) +

  # Make zero line
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", alpha = .4) +
  geom_hline(yintercept = 4, linetype = "dashed", color = "black", alpha = .4)

# Plot relative speed #
df <- data.frame(participantData$Delta)
df$Experience <- participantData$Experience
colnames(df) <- c("Delta", "Experience")
df <- mapply(df, FUN=as.numeric)
df <- data.table(df)

# box = ggplot(df, aes(x = Delta, y = factor(Experience))) +
#   geom_boxplot() +
#   ylab("Virtual Reality Experience [sessions]") + xlab("Relative Speed [μP/μM]") +
#   ggtitle("Relative average guardian speed by virtual reality experience") +
#   scale_y_discrete(labels=c("1-5", "5-14", "15+"))
#
# box = ggplot(df, aes(x = Delta, y = "")) +
#   geom_boxplot() +
#   ylab("") + xlab("Relative Speed [μP/μM]") +
#   ggtitle("Relative average guardian speed over all") +
#   scale_y_discrete(labels=c(""))
#
# box = ggplot(IOM, aes(x = Time, y = factor(Guardian))) +
#   geom_boxplot() +
#   ylab("Guardian") + xlab("Time [s]") +
#   ggtitle("Time taken completing task") +
#   scale_y_discrete(labels=c("Perma", "Meta"))

ggplot(df, aes(x = Delta)) +

  ggtitle("Relative weighted confidence score over all (Normalized)") +

  geom_histogram(aes(y = ..density..), color = "black", fill = "white", binwidth = 1)
  geom_density(alpha = .2, fill = "black") +
  geom_vline(aes(xintercept = 1.0),
             color = "black", linetype = "dashed", size = .5) +

  scale_x_continuous(breaks = seq(-2, 6, by = 1)) +

  ylab("Count") + xlab("Relative weighted confidence [CP/CM]")

df <- participantData$Delta
data_numeric <- as.numeric(df)
hist(data_numeric, breaks = 25)
boxplot(data_numeric)
abline(h = 1, col = "Red")

# box
ggsave(plot, filename = "images/IOM_boxplot.png") # Save graph as PNG

