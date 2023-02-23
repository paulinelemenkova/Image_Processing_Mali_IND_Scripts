# Computing vegetation indices
library(terra)
library(RColorBrewer)
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/NDVI")
# 1. Normalized Difference Vegetation Index (NDVI) = (NIR - R) / (NIR + R), i.e., NDVI = (Band 5 – Band 4) / (Band 5 + Band 4).
vi <- function(img, k, i) {
  bk <- img[[k]]
  bi <- img[[i]]
  vi <- (bk - bi) / (bk + bi)
  return(vi)
}
# For Landsat NIR = 5, red = 4.
filenames <- paste0('LC08_L2SP_197050_20131110_20200912_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
ndvi <- vi(landsat, 5, 4)
options(scipen=10000)
plot(ndvi, col=brewer.pal(11, "RdYlGn"), font.main = 1, main = "NDVI for Landsat-8 OLI/TIRS C1 image LC08_L2SP_197050_20131110_20200912_02_T1_SR: Inner Niger Delta, Mali (2013)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Plotting histogram of the NDVI
hist(ndvi, font.main = 1, main = "NDVI values for Landsat-8 OLI/TIRS C1 image \nLC08_L2SP_197050_20131110_20200912_02_T1_SR: Inner Niger Delta, Mali (2013)", xlab = "NDVI", ylab= "Frequency",
    col = "darkolivegreen1", xlim = c(-0.5, 1),  breaks = 30, xaxt = "n")
axis(side=1, at = seq(-0.6, 1, 0.1), labels = seq(-0.6, 1, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
#
