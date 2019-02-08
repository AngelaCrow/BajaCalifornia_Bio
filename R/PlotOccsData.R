library(raster)
library("rgdal", quietly = TRUE)
library("magrittr", quietly = TRUE)
library("readr", quietly = TRUE)
library("dplyr", quietly = TRUE)


setwd("/Users/angelacuervo/Documents/Wolke/BajaCalifornia_Bio/Botany/data_species/")
outputFolder <- '/Users/angelacuervo/Documents/Wolke/BajaCalifornia_Bio/Botany/data_species/'
mask<-raster("~/Documents/Wolke/Nuevo/mask.tif")
sp_list<-list.files("/Users/angelacuervo/Documents/Wolke/BajaCalifornia_Bio/Botany/data_species/", 
                    pattern = ".csv$*")

#x<-sp_list[1]

plots_sps<-lapply(sp_list, function(x){
  crs.wgs84 <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  occsData <- readr::read_csv(x)
  sp::coordinates(occsData) <- c("Longitude", "Latitude")
  sp::proj4string(occsData) <- crs.wgs84
  occsData <- sp::remove.duplicates(occsData, zero=0.00833333333)
  print(x)
  outname <- paste0("/Users/angelacuervo/Documents/Wolke/BajaCalifornia_Bio/Botany/data_specie/", basename(x))
  png(filename=paste0(basename(x), ".png"))
  plot(mask, col="grey",main = basename(x))
  points(occsData$Longitude, occsData$Latitude, pch='o', col='blue', cex=1.1)
  dev.off()
  write.csv(cbind(occsData@data, coordinates(occsData)), 
            file = file.path(outputFolder, paste0(basename(x),"_", "sinDups",".csv")),
          row.names = FALSE)
})
