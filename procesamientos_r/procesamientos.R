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


#### BARRIOS ####

# No se dispone de la tabla de barrios así que se generará en SQL (queries/tablas_relaciones.sql)

















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
