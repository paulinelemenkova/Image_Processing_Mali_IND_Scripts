library(rgdal)
library(raster)
library(terra)
library(RColorBrewer)
library(pals)
library(colorspace)
library(RStoolbox)
library(graphics)
#
# Set up working directory
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/K-means")
# Importing data
Landsat_2015 <- list.files("/Users/polinalemenkova/Documents/R/52_Image_Processing/K-means")
# Printing the list
list.files()
#
# creating SpatRaster object
landsat <- rast(Landsat_2015)
# check properties
landsat
landsatRGB <- landsat[[c(4,3,2)]]
plotRGB(landsatRGB, r=1, g=2, b=3, axes=FALSE, stretch="lin")
#
# Running the classification
set.seed(25)
unC <- unsuperClass(landsatRGB, nSamples = 100, nClasses = 20, nStarts = 5)
unC
#
# Creating color palette
colors <- jet(20)
# plotting a map
plot(unC$map, main = "K-means Clustering for Landsat-8 OLI/TIRS C1 image of Mali, Inner Niger Delta  \nLC08_L2SP_197050_20151116_20200908_02_T1 (2015)", font.main=1, cex.main = 0.85, col = colors, axes = FALSE, box = FALSE, legend = FALSE)
# adding legend
legend(x = "bottomright", legend=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"), fill = colors, title = "LULC ID Classes", horiz = FALSE,  bty = "n", text.font=1, ncol=1, y.intersp = 0.7)


