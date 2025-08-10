#### Se cargan los paquetes ####

library(dplyr)
library(readr)
library(utils)
library(tidyverse)
library(sf)
library(readxl)
library(dplyr)
library(openxlsx)


#### Se levantan las bases de datos ####

#### USUARIOS: ####

usuarios <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2024.csv", sep = ",")

usuarios_final <- usuarios %>% 
  mutate(id_genero=case_when(genero_usuario=="FEMALE"~1,
                             genero_usuario=="MALE"~2,
                             genero_usuario=="OTHER"~3)) %>% 
  select(1,id_genero,3:5)


# Se guarda el CSV

write.csv(usuarios_final,"insumos/usuarios.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")


# Se guarda una muestra de 1000 casos

write.csv(usuarios_final[1:1000,],"insumos/usuarios_sample.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")


# Limpieza:

rm(usuarios, usuarios_final)


#### RECORRIDOS: ####

# URL

url <- "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/recorridos-realizados-2024.zip"

# Se descarga el zip

download.file(url, destfile = "procesamientos_r/datos.zip", mode = "wb")

# Para deszipear

unzip("procesamientos_r/datos.zip", list = TRUE)

# Se descomprime el csv

unzip("procesamientos_r/datos.zip", files = "badata_ecobici_recorridos_realizados_2024.csv", exdir = "procesamientos_r")

# Se levanta el csv

recorridos <- read_csv("procesamientos_r/badata_ecobici_recorridos_realizados_2024.csv")

# se genera la base de recorridos finales:

recorridos_final <- recorridos %>% 
  mutate(id_mes=month(fecha_origen_recorrido),
         calificacion=sample(1:10, size = n(), replace = TRUE),
         id_modelo=sample(1:2, size = n(), replace = TRUE)) %>% 
  select(id_recorrido,id_usuario,id_estacion_orig=id_estacion_origen,
         id_mes,fecha_origen=fecha_origen_recorrido,
         id_estacion_dest=id_estacion_destino,
         fecha_dest=fecha_destino_recorrido,id_modelo,calificacion,id_precio=id_mes)



# Se guarda el CSV

write.csv(recorridos_final,"insumos/recorridos.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")

# Se guarda una muestra de 1000 casos

write.csv(recorridos_final[1:1000,],"insumos/recorridos_sample.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")



rm(url)


#### ESTACIONES ####

estaciones <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/estaciones-bicicletas-publicas/nuevas-estaciones-bicicletas-publicas.csv")



# Asignación de barrios a las estaciones:

# Se genera un xlsx con id de estación, latitud y longitud

listado_estaciones <- estaciones %>% select(id,latitud,longitud)

# Se descarga el geojson con los barrios de caba:


barrios <- read_sf("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-educacion/barrios/barrios.geojson") %>% 
  rename(barrio=nombre)

# se calculan los puntos en base a la latitud y longitud

puntos <- st_as_sf(listado_estaciones, coords = c("longitud", "latitud"), crs = 4326)

# Se le asigna un barrio a cada id de estación:

puntos_con_barrios <- st_join(puntos, barrios[, c("barrio")], join = st_within) %>% 
  st_drop_geometry()


# Ahora se asignan los barrios a la tabla original de estaciones:

estaciones_2 <-  estaciones %>% 
  select(-c(barrio,comuna,emplazamiento)) %>% 
  left_join(puntos_con_barrios)

# Chequeo de NA en la asignación

chequeo <- estaciones_2 %>% filter(is.na(barrio))  


# Asignación manual de NAS (se genera la base final):

estaciones_2 <- estaciones_2 %>% 
  mutate(barrio=case_when(nombre=="AEROPARQUE"~"Palermo",
                          nombre=="MACACHA GUEMES"~"Belgrano",
                          TRUE~barrio)) %>% 
  select(1:4,7,5,6) %>% 
  arrange(id)

estaciones_final <- estaciones_2 %>% 
  rename(id_estacion=id) %>% 
  mutate(id_barrio=case_when(barrio=="Agronomia"~1,
                             barrio=="Almagro"~2,
                             barrio=="Balvanera"~3,
                             barrio=="Barracas"~4,
                             barrio=="Belgrano"~5,
                             barrio=="Boedo"~6,
                             barrio=="Caballito"~7,
                             barrio=="Chacarita"~8,
                             barrio=="Coghlan"~9,
                             barrio=="Colegiales"~10,
                             barrio=="Constitucion"~11,
                             barrio=="Flores"~12,
                             barrio=="Floresta"~13,
                             barrio=="Boca"~14,
                             barrio=="Paternal"~15,
                             barrio=="Liniers"~16,
                             barrio=="Mataderos"~17,
                             barrio=="Monserrat"~18,
                             barrio=="Monte Castro"~19,
                             barrio=="Nueva Pompeya"~20,
                             barrio=="Nuñez"~21,
                             barrio=="Palermo"~22,
                             barrio=="Parque Avellaneda"~23,
                             barrio=="Parque Chacabuco"~24,
                             barrio=="Parque Chas"~25,
                             barrio=="Parque Patricios"~26,
                             barrio=="Puerto Madero"~27,
                             barrio=="Recoleta"~28,
                             barrio=="Retiro"~29,
                             barrio=="Saavedra"~30,
                             barrio=="San Cristobal"~31,
                             barrio=="San Nicolas"~32,
                             barrio=="San Telmo"~33,
                             barrio=="Velez Sarsfield"~34,
                             barrio=="Versalles"~35,
                             barrio=="Villa Crespo"~36,
                             barrio=="Villa Del Parque"~37,
                             barrio=="Villa Devoto"~38,
                             barrio=="Villa Gral. Mitre"~39,
                             barrio=="Villa Lugano"~40,
                             barrio=="Villa Luro"~41,
                             barrio=="Villa Ortuzar"~42,
                             barrio=="Villa Pueyrredon"~43,
                             barrio=="Villa Real"~44,
                             barrio=="Villa Riachuelo"~45,
                             barrio=="Villa Santa Rita"~46,
                             barrio=="Villa Soldati"~47,
                             barrio=="Villa Urquiza"~48)) %>% 
  select(id_estacion,nombre,direccion,id_barrio,latitud,longitud)

rm(estaciones,estaciones_2)

# Se guarda el CSV

write.csv(estaciones_final,"insumos/estaciones.csv",
           row.names = FALSE,
           na="",
           fileEncoding = "Latin1")














#### Borrar todo esto ####


barrios <- read.csv("barrios_caba.csv")


writexl::write_xlsx(barrios,"barrios.xlsx")

usuarios <- read.csv("usuarios_ecobici_2024.csv")


recorridos <- readRDS("recorridos_2024.rds")

listado_estaciones <- estaciones %>% select(id,latitud,longitud)


writexl::write_xlsx(listado_estaciones,"estaciones_barrio.xlsx")


#### Asignación de barrios a estaciones ####

estaciones <- read.csv("nuevas-estaciones-bicicletas-publicas.csv")

barrios_est <- readxl::read_xlsx("estaciones_con_barrios.xlsx")

listado_estaciones_final <-  estaciones %>% 
  select(-c(barrio,comuna,emplazamiento)) %>% 
  left_join(barrios_est)

chequeo <- listado_estaciones_final %>% filter(is.na(barrio))  


# Asignación manual de NAS:

listado_estaciones_final <- listado_estaciones_final %>% 
  mutate(barrio=case_when(nombre=="AEROPARQUE"~"Palermo",
                          nombre=="MACACHA GUEMES"~"Belgrano",
                          TRUE~barrio)) %>% 
  select(1:4,7,5,6) %>% 
  arrange(id)

# Ahora se asigna un id_barrio:

barrio <- read_xlsx("tabla_barrios.xlsx") %>% 
  select(barrio,id_barrio)


listado_estaciones_final <- listado_estaciones_final %>% 
  left_join(barrio)

# Se guarda las tablas de las estaciones:

writexl::write_xlsx(listado_estaciones_final,"estaciones.xlsx")
