
library(tidyverse)
library(sf)

barrios <- read_sf("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-educacion/barrios/barrios.geojson") %>% 
  rename(barrio=nombre)
  


write_sf(barrios,"barrios_poli.geojson")

#### ASIGNACION ####


library(sf)
library(readxl)
library(dplyr)
library(openxlsx)

# Paso 1: Leer Excel con coordenadas
df <- read.xlsx("estaciones_barrio.xlsx")

# Convertir a objeto espacial
puntos <- st_as_sf(df, coords = c("longitud", "latitud"), crs = 4326)

# Paso 2: Leer archivo GeoJSON de barrios
barrios <- st_read("barrios.geojson")

# Paso 3: Unión espacial (intersección punto dentro de polígono)

puntos_con_barrios <- st_join(puntos, barrios[, c("barrio")], join = st_within)

# Paso 4: Guardar resultado a Excel
puntos_final <- puntos_con_barrios %>% 
  st_drop_geometry()  # quitamos la geometría para guardar como tabla

write.xlsx(puntos_final, "estaciones_con_barrios.xlsx")
