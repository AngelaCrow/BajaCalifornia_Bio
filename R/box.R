library("raster")
library("rgdal" )
library("magrittr")
library("readr")
library("dplyr")
library(ggplot2)
library(ggmap)

setwd("/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela")

outputFolder <- '/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/SinDups_dataSpecies'
output_lentgth<-"/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/length"
mask<-raster("/Users/angelacuervo/Documents/BajaCalifornia_Bio/mask.tif")
sp_list<-list.files("/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/", 
                    pattern = ".csv$*")

#dataFilePath <- '/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela2.csv'
#xy_sp <- data.table::fread(dataFilePath, encoding = "Latin-1")
#bc_bbox <- make_bbox(lat = Latitude, lon = Longitude, data = xy_sp)
#bc_bbox 

xy_df<-data.frame(rasterToPoints(mask)) %>% dplyr::rename(latitude = y, longitude = x )
# compute the bounding box
bc_bbox <- make_bbox(lat = latitude, lon = longitude, data = xy_df)
bc_bbox 

plots_sps<-lapply(sp_list, function(x){
  crs.wgs84 <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  occsData <- readr::read_csv(x) %>% na.omit()
  sp::coordinates(occsData) <- c("Longitude", "Latitude")
  sp::proj4string(occsData) <- crs.wgs84
  occsData <- sp::remove.duplicates(occsData, zero=0.004166667) #0.00833333333
  print(x)
  dups<-data.frame(length(occsData))
  dups["Scientificname"] <-basename(x)%>%gsub(".csv","",.)
  write.csv(dups, file.path(output_lentgth, paste0(basename(x))),
            row.names = FALSE)
  write.csv(cbind(occsData@data, coordinates(occsData)), 
            file = file.path(outputFolder, paste0(basename(x))),
            row.names = FALSE)
  filename<-paste0(basename(x)%>%gsub(".csv","",.))
  # grab the maps from google
bc_big <- get_map(location = bc_bbox, source = "google", maptype = "terrain")
# plot the points and color them by sector
sp<-data.frame(occsData)
ggmap(bc_big) + 
  geom_point(data = sp, mapping = aes(x = Longitude, y = Latitude, color = Source_DB))
ggsave(paste(filename, ".pdf", sep = ""), width = 9, height = 9)
})
