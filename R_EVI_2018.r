# Computing vegetation indices
library(terra)
library(RColorBrewer)
library(Hmisc)
library(pals)
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/EVI")
# For Landsat 8-9 OLI/TIRS, NIR = Band 5, red = Band 4.
filenames <- paste0('LC08_L2SP_197050_20181124_20200830_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
# Enhanced Vegetation Index 2: EVI2 = 2.4 * (Band 5 – Band 4) / (Band 5 + Band 4 + 1).
# The 'lapp' function in SpatRaster numerates the bands from 0: Band 4 = Nr. 3, Band 5 = Nr. 4.
evi2_fun = function(nir, red){
  2.4 * ((nir - red) / (nir + red + 1))
}
evi2 = lapp(landsat[[c(4, 3)]],
            fun = evi2_fun)
evi2
#
colors <- jet(100)
options(scipen=10000)
plot(evi2, col = colors, font.main = 2, main = "Enhanced Vegetation Index 2 (EVI2) for Landsat-8 OLI/TIRS C1 image LC08_L2SP_197050_20181124_20200830_02_T1: Inner Niger Delta, Mali (2018)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Computing histogram for EVI2
hist(evi2, font.main = 1, main = "EVI2 values for Landsat-9 OLI/TIRS C1 image \n LC08_L2SP_197050_20181124_20200830_02_T1, Inner Niger Delta, Mali (2018)", xlab = "SAVI", ylab= "Frequency",
    col = "cyan1", xlim = c(-0.4, 0.4),  breaks = 30, xaxt = "n")
axis(side=1, at = seq(-0.4, 0.4, 0.1), labels = seq(-0.4, 0.4, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
