# Computing vegetation indices
library(terra)
library(RColorBrewer)
library(Hmisc)
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/SAVI")
# For the Landsat 8-9, NIR = Band 5, red = Band 4.
filenames <- paste0('LC08_L2SP_185051_20131122_20200912_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
# Soil Adjusted Vegetation Index (SAVI) corrects NDVI for the influence of soil brightness in areas where vegetative cover is low
# SAVI = ((Band 5 – Band 4) / (Band 5 + Band 4 + 0.5)) * (1.5).
# The 'lapp' function in SpatRaster numerates the bands from 0: Band 4 = Nr. 3, Band 5 = Nr. 4.
savi_fun = function(nir, red){
  ((nir - red) / (nir + red + 0.5)) * 1.5
}
savi = lapp(landsat[[c(4, 3)]],
            fun = savi_fun)
options(scipen=10000)
plot(savi, col = rev(brewer.pal(11, "Spectral")), font.main = 1, main = "SAVI for Landsat-8 OLI/TIRS C1 image LC08_L2SP_197050_20131110_20200912_02_T1_SR: Inner Niger Delta, Mali (2013)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Plotting the histogram of SAVI
hist(savi, font.main = 1, main = "SAVI values for Landsat-8 OLI/TIRS C1 image \nLC08_L2SP_197050_20131110_20200912_02_T1_SR: Inner Niger Delta, Mali (2013)", xlab = "NDVI", ylab= "Frequency",
    col = "chocolate1", xlim = c(-0.5, 1),  breaks = 30, xaxt = "n")
axis(side=1, at = seq(-0.6, 1, 0.1), labels = seq(-0.6, 1, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
#
