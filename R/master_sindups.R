
setwd("C:/Proyectos/Wolke/BajaCalifornia_Bio/Botany/length")
#x<-sp_list[1]
#x

temp <- list.files('C:/Proyectos/Wolke/BajaCalifornia_Bio/Botany/length', pattern="*.csv")

myfiles <- lapply(temp, read.delim, sep = ",")

master<- data.table::rbindlist(myfiles)

write.csv(master, "Master Baja Botany Points_sinDups.csv", row.names = FALSE)
