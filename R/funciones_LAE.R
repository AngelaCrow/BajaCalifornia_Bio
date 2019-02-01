# -------------------------------------------------------------------------
# Functiones para paper particiones
# Presenta una galería de funciones para calcular metricas
# de desempeño de los modelos de distribcuion
# Creador: Luis Osorio
# 11-Abril-2016
# -------------------------------------------------------------------------
pkgs <- c("Metrics","raster")
not_in <- pkgs[!pkgs %in% installed.packages()] 
if(length(not_in)){
  install.packages(not_in,repos = "https://cloud.r-project.org/")
}
library(Metrics)
library(raster)


f_error_com <- function(b,d)    return(b/(b+d))
f_error_om <- function(a,c)  return( c/(a+c))
sensibilidad <- function(a,c)  return(a/(a+c))
especificidad <- function(b,d)  return(d/(b+d))
#tas_clas_cor <- function(a,d) return((a+d)/(a+b+c+d)) 
tas_fals_pos <- function(b,d) return(b/(b+d))
tas_fals_neg <- function(a,c) return(c/(a+c))
posit_pre_pow <- function(a,b) return(a/(a+b))
nega_pre_pow <- function(c,d) return(d/(c+d))
miss_cla_rate <- function(a,b,c,d) return((b+c)/(a+b+c+d))
prevalencia <- function(a,b,c,d) return((a + c)/(a+b+c+d))
correct_class_rate <- function(a,b,c,d) return((a + d)/(a+b+c+d))
tss <- function(a,b,c,d) return(sensibilidad(a,c)+especificidad(b,d)-1)
kappa <- function(a,b,c,d){
  N <- a+b+c+d
  term1 <- ((a+d)-(((a+c)*(a+b)+(b+d)*(c+d))/N))
  term2 <- (N-(((a+c)*(a+b)+(b+d)*(c+d))/N))
  return(term1/term2)
}


confu_mat_con <- function(rasterBinary,valData,x,y){
  
  values <- extract(rasterBinary,valData[,c(x,y)])
  na <- which(is.na(values))
  
  if(length(na)>0L){
    values <- values[-na]
    obs <- valData[,3][-na]#Modificar segun columna de 0 y 1
    
  }
  else{
    obs <- valData[,3]#modificar segun columna de 0 y 1
  }

  comb <- paste0(values,obs)
  nobs <- length(comb)
  a1 <- numeric(nobs)
  b1 <- numeric(nobs)
  c1 <- numeric(nobs)
  d1 <- numeric(nobs)
  auc1 <- numeric(nobs)
  
  for(i in 1:nobs){
    if(comb[i] == "11") a1[i] <- 1
    if(comb[i] == "10") b1[i] <- 1
    if(comb[i] == "01") c1[i] <- 1
    if(comb[i] == "00") d1[i] <- 1
    if(comb[i] == "00" || comb[i]=="11") auc1[i] <- 1
  }
  
  a <- sum(a1)
  b <- sum(b1)
  c <- sum(c1)
  d <- sum(d1)
  
  kappa1 <- kappa(a = a,b = b,c = c,d = d)
  tss1 <- tss(a = a,b = b,c = c,d = d)
  correct_class_rate1 <- correct_class_rate(a = a,b = b,c = c,d = d)
  prevalence <- prevalencia(a = a,b = b,c = c,d = d)
  AUC <- Metrics::auc(auc1, values)
  
  
  df_results <- data.frame(  a=a,b=b,c=c,d=d,
                             AUC = round(AUC,4),
                             kappa=round(kappa1,4),tss=round(tss1,4),
                             prevalence=round(prevalence,4),
                             specificity =round(especificidad(b,d),4),
                             sensibility = round(sensibilidad(a,c),4),
                             correct_class_rate= round(correct_class_rate1,4),
                             miss_cla_rate = round(miss_cla_rate(a = a,b = b,c = c,d = d),4),
                             posit_pre_pow = round(posit_pre_pow(a,b),4),
                             nega_pre_pow = round(nega_pre_pow (c,d),4),
                             comission_error = round(tas_fals_pos(b,d),4),
                             omission_error = round(tas_fals_neg(a,c),4))
  return(df_results)
}



