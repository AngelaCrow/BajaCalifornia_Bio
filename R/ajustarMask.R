library(raster)
#setwd("C:/Proyectos/Wolke/Nuevo/Resultados_Herpetos_VaraiablesBaja")
setwd("~/Documents/Wolke/Nuevo/")
dir.create("Resultados_Herpeto_VaraiablesBaja/mascara/")

#Este codigo es para cortar un mapa de distribucion potencial continuo con el mapa binario correspondiente. 
#Ademas lo ajusta a una misma mascara, dejandolo con el mismo numero de columnas y filas. 
rm(list=ls())
#mask<-raster("C:/Proyectos/Wolke/mask.tif")
mask<-raster("mask.tif")
print(mask)
newextent<-c(-118.375,-107.85,22.51271, 32.66271)#binarios <- Sys.glob("acutiacutifolius/*.tif$")
binarios <- list.files("Resultados_Herpeto_VaraiablesBaja", 
                       pattern = "_min_", full.names = T, recursive = T)

binarios
#x<-binarios[[43]]
nuevoExt<-lapply(binarios, function(x){
  mapa<-raster(x)
  print(x)
  sp_map<-extend(mapa, newextent)
  sp_map[is.na(sp_map[])] <- 0
  final <- mask*sp_map
  outname <- paste0("Resultados_Herpeto_VaraiablesBaja/mascara/", basename(x))
  png(filename=paste0(basename(x), ".png"))
  plot(final, main = basename(x))
  dev.off()
  writeRaster(final, outname, overwrite = TRUE)
})

