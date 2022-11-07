# http://www.sthda.com/english/wiki/impressive-package-for-3d-and-4d-graph-r-software-and-data-visualization

library(plot3D)

matrixSize = 25 # Number of physical "fields" in each dimension
placementPath = "placement2.csv"

placeData <- read.csv(placementPath, header=FALSE) # Read data from file
placeData <- t(placeData) # Transpose data

boxNumbers = list()

for (i in 1:ncol(placeData)) {
  tmp_participant <- matrix(unlist(placeData[ , i]), nrow=rowLength) # Cut to matrix
  rownames(tmp_participant) <- c("X", "Y", "Z", "W") # Column names
  tmp_participant <- t(tmp_participant) # Transpose
  tmp_participant <- data.table(tmp_participant)

  boxNumber <- round(tmp_participant$X * matrixSize + tmp_participant$Z)
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
placeValues = placeValues * 10

x = seq(-matrixSize/2+1, matrixSize/2, by=1)
y = seq(matrixSize/2, -matrixSize/2+1, by=-1)

# Convert Z values into a matrix.
z = matrix(placeValues, nrow=matrixSize, ncol=matrixSize, byrow=TRUE)

hist3D(
  x, y, z,
  main="Placement representation each frame",
  clab=c("Frame count", "Normalized"),
  colkey=list(side=4, length=0.5, width=0.5),
  theta=-45, phi=30, bty="b2",
  col = c("#0AE4F0", "#0253F2", "#4409DB","#E20CF5", "#EB0A09"),
  axes=TRUE, label=FALSE, ticktype="detailed",
  nticks=matrixSize, space=0.2,
  lighting=TRUE, shade=0.9)
