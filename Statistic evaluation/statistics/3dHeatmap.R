# http://www.sthda.com/english/wiki/impressive-package-for-3d-and-4d-graph-r-software-and-data-visualization

library(plot3D)
library(data.table)

matrixSize = 25 # Number of physical "fields" in each dimension
rowLength = 4 # Amount of columns
placementPath = "placement3.csv"

placeData <- read.csv(placementPath, header=FALSE) # Read data from file
placeData <- t(placeData) # Transpose data

boxNumbers = list() # Empty list for boxes
for (i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow=rowLength) # Cut to matrix
  rownames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  tmp_participant <- data.table(tmp_participant)

  # Calculate box number and append til list
  halfX = tmp_participant$X + matrixSize / 2
  halfZ = tmp_participant$Z + matrixSize / 2
  boxNumber <- round(halfX * matrixSize + halfZ)
  boxNumbers <- rbind(boxNumbers, boxNumber)
}

###############################################################

# Constant variables
fields = matrixSize * matrixSize # Total amount of "fields"

# Construct matrix/grid
x <- paste0(1:matrixSize) # Make x-axis
y <- paste0(1:matrixSize) # Make y-axis
heatmapData <- expand.grid(X=x, Y=y) # Make grid

# Convert data to histogram
placeList <- unlist(as.list(boxNumbers)) # Flatten placement matrix
placeHist <- hist(placeList, breaks=0:fields) # Get histogram of "placement"
placeValues <- placeHist$counts # Get counts in histogram
placeValues = (placeValues-min(placeValues))/(max(placeValues)-min(placeValues))
placeValues = placeValues # * 10

x = seq(-matrixSize/2+1, matrixSize/2, by=1)
y = seq(matrixSize/2, -matrixSize/2+1, by=-1)

# Convert Z values into a matrix.
z = matrix(placeValues, nrow=matrixSize, ncol=matrixSize, byrow=TRUE)

plot <- hist3D(
  x, y, z,
  main="Placement representation each frame",
  clab=c("Frame count", "(Normalized)"),
  colkey=list(side=4, length=.7, width=.5),
  theta=135, phi=30, bty="b2",
  col = c("#0AE4F0", "#0253F2", "#4409DB","#E20CF5", "#EB0A09"),
  nticks=matrixSize/4, ticktype="detailed", space=0.2, shade=0.9)
