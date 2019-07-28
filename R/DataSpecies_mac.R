library(dplyr)

dataFilePath <- '/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela2.csv'
outputDataFolder <- '/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/'

especieData <- data.table::fread(dataFilePath, encoding = "Latin-1")
#Endemismos<-filter(especieData, Endemic == "1")

#dataFilePath <- 'C:/Proyectos/Wolke/BajaCalifornia_Bio/Botany/data_species/Endemic.csv'

especieData[,
            data.table::fwrite(
              .SD,
              file.path(outputDataFolder,
                        paste0(gsub('([[:punct:]])|//s+','_', Species),
                               ".csv"))),
            by = .(Species)]
