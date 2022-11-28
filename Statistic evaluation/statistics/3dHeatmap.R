# http://www.sthda.com/english/wiki/impressive-package-for-3d-and-4d-graph-r-software-and-data-visualization

library(plot3D)
library(data.table)

matrixSize = 9 # Number of physical "fields" in each dimension
guardianSize = 3
rowLength = 4 # Amount of columns
placementPath = "oneLineLocations.csv"
showPermaGuardian = TRUE

placeData <- read.csv(placementPath, header=FALSE) # Read data from file
# placeData <- t(c(0, 0, 0, 0, 4, 0, 0, 0))
placeData <- t(placeData) # Transpose data

boxNumbers = list() # Empty list for boxes
for (i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow=rowLength) # Cut to matrix
  rownames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  tmp_participant <- data.table(tmp_participant)

  # Calculate box number and append til list
  halfX = round(tmp_participant$X * 2 + matrixSize / 2 - .5) # + 2
  halfZ = round(tmp_participant$Z * 2 + matrixSize / 2 + .5) # + 2
  boxNumber <- (halfX * matrixSize + halfZ)
  if (i %% 2 == as.integer(showPermaGuardian)) {
    boxNumbers <- rbind(boxNumbers, boxNumber)
  }
}
boxNumbers

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

hist3D(
  x, y, z,
  main="Placement representation each frame",
  clab=c("Frame count", "(Normalized)"),
  colkey=list(side=4, length=.7, width=.5),
  theta=110, phi=25, bty="b2",
  col = jet.col(10, alpha=.8),
  nticks=matrixSize*.5, ticktype="detailed", space=0.2)

box3D(x0=-guardianSize, y0=-guardianSize, z0=0,
      x1=guardianSize+1, y1=guardianSize+1, z1=1,
      col="lightblue", alpha=.2,
      border="lightgrey", lwd=1, add=TRUE)
