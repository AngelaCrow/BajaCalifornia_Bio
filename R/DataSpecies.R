#library(dplyr)

dataFilePath <- '/Users/angelacuervo/Documents/Wolke/BajaCalifornia_Bio/Botany/Endemismos.csv'
outputDataFolder <- '/Users/angelacuervo/Documents/Wolke/BajaCalifornia_Bio/Botany/data_species/'

#especieData <- data.table::fread(dataFilePath, encoding = "Latin-1")
#Endemismos<-filter(especieData, Endemismos == "1")
#write_csv(Endemismos, "/Users/angelacuervo/Documents/Wolke/BajaCalifornia_Bio/Botany/Endemismos.csv")

especieData[,
            data.table::fwrite(
              .SD,
              file.path(outputDataFolder,
                        paste0(gsub('([[:punct:]])|\\s+','_', Scientific_name),
                               ".csv"))),
            by = .(Scientific_name)]
