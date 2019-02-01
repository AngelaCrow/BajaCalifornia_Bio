setwd("F:/COBERTURAS/Envirem_ChelsaWCrad")
#F:\COBERTURAS\Envirem_ChelsaWCrad\processed
varnames <- list.files("F:/COBERTURAS/CHELSA/Mexico/Tmean",  full.names = TRUE) #cambiar nombre especie
varnames
new_names <-gsub(varnames,replacement = "tmean_",pattern = "CHELSA_temp10_")
file.rename(from = varnames,to = new_names)

require(envirem)
require(raster)

verifyFileStructure("processedok", returnFileNames = FALSE, rasterExt = '.tif')

inputDir <- 'F:/COBERTURAS/Envirem_ChelsaWCrad/processedok'
outDir <- 'F:/COBERTURAS/Envirem_ChelsaWCrad/envirem'

tileNum <- 0

generateRasters(var = 'all', maindir = inputDir, resName = '30s', 
                timeName = 'current', outputDir = outDir, rasterExt = ".tif",
                nTiles = 1, tempScale = 1, overwriteResults = TRUE, outputFormat = "GTiff")
list.files("F:/COBERTURAS/Envirem_ChelsaWCrad/envirem/current/30s")
