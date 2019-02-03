library(ROCR)
library(stringr)
library(raster)

#setwd("C:/Proyectos/Wolke/Nuevo/Resultados_plantas_VaraiablesBaja")
setwd("~/Documents/Wolke/Nuevo/Resultados_Escorpiones_VariablesBaja")
dir.create("pa")

p_files <- list.files(pattern="*_Validacion.csv$",
                      full.names = TRUE,  recursive = T)
p_files
a_files <- list.files(pattern="*_validacion.csv$",
                      full.names = TRUE, recursive = T)
a_files

unir_pa <- lapply(1:length(p_files), function(x){
  filename <- stringr::str_remove(basename(p_files[[x]]), "_Validacion.csv$")
  presencias <- read.csv(p_files[[x]])
  names(presencias) <- c("x", "y")
  presencias["Presencia"] <- "1"
  ausencias <- read.csv(a_files[[x]])
  ausencias["Presencia"] <- "0"
  pa <- rbind(presencias,ausencias)
  names(pa) <- c("x", "y", "PresenciaAusencia")
  print(filename)
  write.csv(pa, file = paste0("pa/", filename,"_pa.csv"), row.names = F)
  return(1)
})

###AUC
setwd("C:/Proyectos/Wolke/Nuevo/Resultados_plantas_VaraiablesBaja")

sp_models <- list.files(pattern = "_log_", full.names = T, recursive = T)
sp_models
p_files <- list.files(pattern="*_Validacion.csv$",
                      full.names = TRUE,  recursive = T)
p_files
a_files <- list.files(pattern="*_validacion.csv$",
                      full.names = TRUE, recursive = T)
a_files

#presencias <- read.csv(p_files[[48]])
#ausencias <- read.csv(a_files[[48]])
#model<-raster(sp_models[[48]]) 

val_auc <-  lapply(1:length(p_files), function(x){
  filename <- stringr::str_remove(basename(p_files[[x]]), "_Validacion.csv$")
  presencias <- read.csv(p_files[[x]])
  print(p_files[[x]])
  col.p <- c("Long", "Lat")
  presencias<-presencias[col.p]
  ausencias <- read.csv(a_files[[x]])
  print(a_files[[x]])
  col.a <- c("x", "y")
  ausencias<-ausencias[col.a]
  model<-raster(sp_models[[x]]) 
  names(model)
  testpp <- extract(model, presencias)
  abs <- extract(model, ausencias)
  combined <- c(testpp, abs)       
  label <- c(rep(1,length(testpp)),rep(0,length(abs)))  
  pred <- prediction(combined, label)   
  perf <- performance(pred, "tpr", "fpr")               # True / false positives, for ROC curve
  auc <- performance(pred, "auc")@y.values[[1]] 
  print(filename)
  return(c(filename,auc))
})

df<-as.data.frame(do.call(rbind, val_auc))
write.csv(df, "AUC.csv", row.names = F)


