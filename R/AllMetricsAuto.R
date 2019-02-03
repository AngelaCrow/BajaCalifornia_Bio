# Driectorio de trabajo
setwd("C:/Proyectos/Wolke/")
setwd("~/Documents/Wolke/BajaCalifornia_Bio/R")
# Cargar funciones 
source("funciones_LAE.R")
# Path de carpeta con los datos de Validacion
# Los datos tienen que tener el siguiente formato
#------------------------------------------------
# x          |    y       | PresenciaAusencia
# -121.3999  |  28.377    |         1 
# -108.9937  |  28.28767  |         0
#------------------------------------------------

#Umbral con el minimo####
valDataPaths <- list.files("~/Documents/Wolke/Nuevo/Resultados_Mamiferos_VaraiablesBaja/pa/",pattern = "*.csv$", full.names = T)
valDataPaths
valDataList <- lapply(valDataPaths, function(x) read.csv(x,header=T))
# Path de la carpeta con los binaris de los modelos 
rasterBinaryPaths <- list.files("~/Documents/Wolke/Nuevo/Resultados_Mamiferos_VaraiablesBaja", pattern = "_min_", full.names = T, recursive = T)
rasterBinaryPaths
rasterBinayList <- lapply(rasterBinaryPaths, function(x) raster(x))
x<-rasterBinayList[[1]]
j<-valDataPaths[[1]]
names(x)
j
# Correr la funcion 

#Modelos<-list.files("C:/Proyectos/Wolke/Nuevo/Resultados_plantas_VaraiablesBaja", pattern = "_min_", full.names = T, recursive = T)

allMetrics <-  lapply(1:length(rasterBinaryPaths), function(x){

  sp_path <- rasterBinaryPaths[x]
  sp_name <-gsub(pattern = "Modelos",sp_path,replacement = "") 
  sp_name <- gsub(pattern = "_min_.tif",sp_name,replacement = "")
  print(sp_name)
  print(rasterBinayList[[x]])
  resul <- cbind(sp_name,confu_mat_con(rasterBinary = rasterBinayList[[x]],
                                       valData = valDataList[[x]] ,x ="x",y="y"))
  
  return(resul)
  
})

allMetricsDF <- do.call("rbind.data.frame",allMetrics)
# Escribir los resultados
write.csv(allMetricsDF,file = "~/Documents/Wolke/Nuevo/Resultados_Mamiferos_VaraiablesBaja/AllMetrics_min.csv",row.names = F)

rm(allMetricsDF)

#Umbral con el q10####
# Path de la carpeta con los binaris de los modelos 
rasterBinaryPaths <- list.files("~/Documents/Wolke/Nuevo/Resultados_Mamiferos_VaraiablesBaja", pattern = "_q10_", full.names = T, recursive = T)
rasterBinaryPaths
rasterBinayList <- lapply(rasterBinaryPaths, function(x) raster(x))
x<-rasterBinayList[[1]]
j<-valDataPaths[[1]]
names(x)
j

#Modelos<-list.files("C:/Proyectos/Wolke/Nuevo/Resultados_plantas_VaraiablesBaja", pattern = "_q10_", full.names = T, recursive = T)

# Correr la funcion 
allMetrics <-  lapply(1:length(rasterBinaryPaths), function(x){
  
  sp_path <- rasterBinaryPaths[x]
  sp_name <-gsub(pattern = "Modelos",sp_path,replacement = "")
  sp_name <- gsub(pattern = "min.tif",sp_name,replacement = "")
  print(sp_name)
  print(rasterBinayList[[x]])
  resul <- cbind(sp_name,confu_mat_con(rasterBinary = rasterBinayList[[x]],
                                       valData = valDataList[[x]] ,x ="x",y="y"))
  
  return(resul)
  
})

allMetricsDF <- do.call("rbind.data.frame",allMetrics)
# Escribir los resultados
write.csv(allMetricsDF,file = "~/Documents/Wolke/Nuevo/Resultados_Mamiferos_VaraiablesBaja/AllMetrics_q10.csv",row.names = F)

