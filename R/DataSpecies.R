library(dplyr)

dataFilePath <- 'G:/Mi unidad/BajaCalifornia_Bio/Angela/Master_botany_all_Angela.csv'
outputDataFolder <- 'C:/Proyectos/Wolke/Master_botany_all_Angela/'

especieData <- data.table::fread(dataFilePath, encoding = "Latin-1")
#Endemismos<-filter(especieData, Endemic == "1")

dataFilePath <- 'C:/Proyectos/Wolke/BajaCalifornia_Bio/Botany/data_species/Endemic.csv'

especieData[,
            data.table::fwrite(
              .SD,
              file.path(outputDataFolder,
                        paste0(gsub('([[:punct:]])|//s+','_', Original_taxon_scientific_name),
                               ".csv"))),
            by = .(Original_taxon_scientific_name)]
