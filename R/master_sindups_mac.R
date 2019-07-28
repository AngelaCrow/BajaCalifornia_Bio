
setwd("/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/length_")
#x<-sp_list[1]
#x

temp <- list.files('/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_botany_all_Angela/length_', pattern="*.csv")

myfiles <- lapply(temp, read.delim, sep = ",")

master_<- data.table::rbindlist(myfiles) %>% 
  rename(No_Occurrence = length.occsData.ID.) %>% 
  arrange(No_Occurrence) 

master_fl_<- data.table::rbindlist(myfiles) %>% 
  rename(No_Occurrence = length.occsData.ID.) %>% 
  arrange(No_Occurrence) %>% 
  filter(No_Occurrence > 24)

write.csv(master_fl, "/Users/angelacuervo/Documents/BajaCalifornia_Bio/Master_Botany_all_sinDups_fl.csv", row.names = FALSE)
