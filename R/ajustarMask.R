library(raster)
setwd("C:/Proyectos/Wolke/Nuevo/Resultados_plantas_VaraiablesBaja")
dir.create("mascara/")

#Este codigo es para cortar un mapa de distribucion potencial continuo con el mapa binario correspondiente. 
#Ademas lo ajusta a una misma mascara, dejandolo con el mismo numero de columnas y filas. 
rm(list=ls())
mask<-raster("C:/Proyectos/Wolke/mask.tif")
print(mask)
newextent<-c(-118.375,-107.85,22.51271, 32.66271)#binarios <- Sys.glob("acutiacutifolius/*.tif$")
binarios <- list.files("C:/Proyectos/Wolke/Nuevo/Resultados_plantas_VaraiablesBaja", 
                       pattern = "_q10_", full.names = T, recursive = T)

binarios
#x<-binarios[[1]]
nuevoExt<-lapply(binarios, function(x){
  mapa<-raster(x)
  print(x)
  sp_map<-extend(mapa, newextent)
  final <- mask*sp_map
  outname <- paste0("mascara/", basename(x))
  png(filename=paste0(basename(x), ".png"))
  plot(final, main = basename(x))
  dev.off()
  writeRaster(final, outname, overwrite = TRUE)
})

#####
hacerLoQueQuiero <- lapply(binarios, function(x, mask){ 
  u <- raster(x)
  print(u)
  #u<-resample(u, mask)
  u[is.na(u[])] <- 0
  final <- mask*u
  NAvalue(final) <- 0
  outname <- paste0("mascara", basename(x))
  plot(final, main = basename(x))
  
  writeRaster(final, outname, overwrite = TRUE)
})

apply(binarios, 1, hacerLoQueQuiero, mask = mask)

