# http://www.sthda.com/english/wiki/impressive-package-for-3d-and-4d-graph-r-software-and-data-visualization

library(plot3D)
library(data.table)

matrixSize = 15 # Number of physical "fields" in each dimension
guardianSize = 3
locDataLength <- 4 # Amount of columns
placementPath = "oneLineLocations_normalized.csv"
surveyPath <- "surveyAnswers_sorted_inverted.csv" # CSV-path for survey data
showGuardian = 2
guardians <- c("Perma", "Meta") # Guardian names
colors <- c('#D0312D', '#1AA7EC') # Colors used in plot for guardian

########## Get survey data ##########
surveyData <- read.csv(surveyPath, header = FALSE) # Read data from file
surveyData <- t(surveyData) # Transpose data
guardianOrder <- surveyData[c(1, 12),] # Get activated guardian


########## Get placement data ##########
fileIn <- file(placementPath, open="rb", encoding="UTF-8") # Read data from file
lines <- readLines(fileIn, n = 1000, warn = TRUE) # Read each line into a list

boxNumbersPerma = strtoi(list()) # Empty list for boxes
for (i in 1:length(lines)) {

  line <- gsub(" ", "", lines[i], fixed = FALSE) # Remove whitespace
  line <- strsplit(line, ",") # Split string at ","/comma
  tmp_participant <- data.table(t(matrix(unlist(line), nrow = locDataLength)))

  tmp_participant <- mapply(tmp_participant, FUN=as.numeric) # Make matrix numeric
  tmp_participant <- data.table(tmp_participant) # Remake data.table matrix
  tmp_participant <- na.omit(tmp_participant) # Remove NaN data values

  colnames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names

  # Calculate box number and append til list
  halfX = round(tmp_participant$X * guardianSize + matrixSize / 2 - .5)
  halfZ = round(tmp_participant$Z * guardianSize + matrixSize / 2 + .5)

  boxNumber <- (halfX * matrixSize + halfZ)

  if (guardianOrder[i] == showGuardian) {
    boxNumbersPerma <- rbind(boxNumbersPerma, boxNumber)
  }
  print((as.numeric(tmp_participant$X)))
}

###############################################################

# Constant variables
fields = matrixSize * matrixSize # Total amount of "fields"

tmp_box <- boxNumbersPerma

# Construct matrix/grid
x <- paste0(1:matrixSize) # Make x-axis
y <- paste0(1:matrixSize) # Make y-axis
tmp_heat <- expand.grid(X = x, Y = y) # Make grid

# Convert data to histogram
placeList <- (unlist(tmp_box)) # Flatten placement matrix
min(placeList)
max(placeList)
placeHist <- hist(placeList, breaks=0:fields) # Get histogram of "placement"
placeValues <- placeHist$counts # Get counts in histogram
placeValues = (placeValues-min(placeValues))/(max(placeValues)-min(placeValues))
tmp_heat$value <- placeValues # Insert "placement" data to heatmap

tmp_heat <- mapply(tmp_heat, FUN=as.numeric)
tmp_heat <- data.table(tmp_heat)

ggplot() + coord_equal() +

  ggtitle(paste(c(guardians[showGuardian], "heatmap tracking location for each frame"), collapse=" ")) +

  geom_tile(data = tmp_heat,
  aes(x = X, y = Y, fill = value), # Insert data
  color = "white", lwd = 1, linetype = 1) + # Margin line

  scale_fill_gradientn(
    colours = c("white", "blue", "red"), # Gradient color
    values = scales::rescale(c(-1, -0.5, 0, 0.5, 1))) + # Gradient scale

  scale_x_continuous(
    breaks = seq(1, 15, by = 1),
    label = seq(-matrixSize/2 + .5, matrixSize/2 - .5, by = 1)) +

  scale_y_continuous(
    breaks = seq(1, 15, by = 1),
    label = seq(-matrixSize/2 + .5, matrixSize/2 - .5, by = 1)) +

  xlab("X") + ylab("Z") +

  geom_rect(aes(
    xmin = matrixSize / 2 - matrixSize / guardianSize + 1, ymin = matrixSize / 2 - matrixSize / guardianSize + 1,
    xmax = matrixSize / 2 + matrixSize / guardianSize, ymax = matrixSize / 2 + matrixSize / guardianSize),
    alpha = .0, color = "grey", fill = "white", lwd = 2.5) +

  # Update legend properties
  theme(
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10)) +

  guides(fill = guide_colourbar(
    barwidth = 1, barheight = 10, # Legend properties
    title = "Density")) # Title text


x = seq(-matrixSize/2 + 1, matrixSize/2, by = 1)
y = seq(matrixSize/2, -matrixSize/2 + 1, by = -1)

# Convert Z values into a matrix.
z = matrix(placeValues, nrow = matrixSize, ncol = matrixSize, byrow = TRUE)

# hist3D(
#   x, y, z,
#   main = paste(c(guardians[showGuardian], "3D heatmap tracking location for each frame"), collapse=" "),
#   clab = "Density",
#   colkey = list(side = 4, length = .7, width = .5),
#   theta = 110, phi = 35, bty = "b2",
#   col = jet.col(10, alpha = .8),
#   nticks = matrixSize * .5, ticktype = "detailed", space = 0.2)
#
# box3D(x0 = - matrixSize / guardianSize + 1, y0 = -matrixSize / guardianSize + 1, z0 = 0,
#       x1 = matrixSize / guardianSize, y1 = matrixSize / guardianSize, z1 = 1,
#       col = "lightblue", alpha = .2,
#       border = "lightgrey", lwd = 1, add = TRUE)

# box
# ggsave(test, filename = "images/IOM_boxplot.png") # Save graph as PNG
