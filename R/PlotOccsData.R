library("raster")
library("rgdal" )
library("magrittr")
library("readr")
library("dplyr")

setwd("C:/Proyectos/Wolke/Master_botany_all_Angela/")

outputFolder <- 'C:/Proyectos/Wolke/Master_botany_all_Angela/SinDups_dataSpecies'
output_lentgth<-"C:/Proyectos/Wolke/Master_botany_all_Angela/length"
mask<-raster("C:/Proyectos/Wolke/BajaCalifornia_Bio/mask.tif")
sp_list<-list.files("C:/Proyectos/Wolke/Master_botany_all_Angela/", 
                    pattern = ".csv$*")

x<-sp_list[6]

plots_sps<-lapply(sp_list, function(x){
  crs.wgs84 <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  occsData <- readr::read_csv(x) %>% na.omit()
  sp::coordinates(occsData) <- c("Longitude", "Latitude")
  sp::proj4string(occsData) <- crs.wgs84
  occsData <- sp::remove.duplicates(occsData, zero=0.00833333333)
  print(x)
  dups<-data.frame(length(occsData))
  dups["Scientificname"] <-basename(x)%>%gsub(".csv","",.)
  write.csv(dups, file.path(output_lentgth, paste0(basename(x))),
            row.names = FALSE)
  png(filename=paste0(basename(x)%>%gsub(".csv","",.), ".png"))
  plot(mask, col="grey",main = basename(x)%>%gsub(".csv","",.))
  points(occsData$Longitude, occsData$Latitude, pch='o', col='blue', cex=1.1)
  dev.off()
  write.csv(cbind(occsData@data, coordinates(occsData)), 
            file = file.path(outputFolder, paste0(basename(x))),
          row.names = FALSE)
})
