library(dplyr)

dataFilePath <- 'G:/Mi unidad/BajaCalifornia_Bio/Species_DB/Angela/Master Baja Botany Points.csv'
outputDataFolder <- 'C:/Proyectos/Wolke/BajaCalifornia_Bio/Botany/data_species/'

especieData <- data.table::fread(dataFilePath, encoding = "Latin-1")
Endemismos<-filter(especieData, Endemic == "1")
write.csv(Endemismos, "C:/Proyectos/Wolke/BajaCalifornia_Bio/Botany/data_species/Endemic.csv")

dataFilePath <- 'C:/Proyectos/Wolke/BajaCalifornia_Bio/Botany/data_species/Endemic.csv'

especieData[,
            data.table::fwrite(
              .SD,
              file.path(outputDataFolder,
                        paste0(gsub('([[:punct:]])|//s+','_', StudyPlant),
                               ".csv"))),
            by = .(StudyPlant)]
