library("raster")
library("rgdal" )
library("magrittr")
library("readr")
library("dplyr")


setwd("/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela")

output_lentgth<-"/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/length_"
sp_list<-list.files("/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/", 
                    pattern = ".csv$*")

#x<-sp_list[13000]
#x

plots_sps<-lapply(sp_list, function(x){
  occsData <- readr::read_csv(x) %>% na.omit()
  print(x)
  len<-data.frame(length(occsData$ID))
  len
  len["Scientificname"] <-basename(x)%>%gsub(".csv","",.)
  write.csv(len, file.path(output_lentgth, paste0(basename(x))),
            row.names = FALSE)
})
