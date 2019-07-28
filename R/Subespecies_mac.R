library(dplyr)
library(tidyverse)

dataFilePath <- '/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela2.csv'

especieData <- data.table::fread(dataFilePath, encoding = "Latin-1")

x<-especieData%>%
  mutate(Species_original = Species) %>% 
  separate(Species, c("genero", "especie", "Infraspecific ranks"), sep=" ") %>% 
  unite("Species", c("genero", "especie"), sep= " ") 

write.csv(x, "/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela3.csv")


