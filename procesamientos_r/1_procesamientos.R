#### Se cargan los paquetes ####

library(dplyr)
library(readr)
library(utils)
library(tidyverse)
library(sf)
library(readxl)
library(dplyr)
library(openxlsx)
library(janitor)

#### Se levantan las bases de datos ####

#### USUARIOS: ####

# 2024

usuarios_2024 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2024.csv", sep = ",") %>% 
  clean_names() %>% 
  mutate(anio=2024)

usuarios_2023 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2023.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2023)


usuarios_2022 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2022.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2022)

usuarios_2021 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2021.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2021)


usuarios_2020 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2020.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2021)


usuarios_2019 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2019.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2019)


usuarios_2018 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios-ecobici-2018.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2018)


usuarios_2017 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios-ecobici-2017.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2017)

usuarios_2016 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios-ecobici-2016.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2016)


usuarios_2015 <- read.csv("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/transporte-y-obras-publicas/bicicletas-publicas/usuarios_ecobici_2025.csv", sep = ",") %>% 
  clean_names() %>% 
  select(1:5)%>% 
  mutate(anio=2015) %>% 
  rename(id_usuario=id_cliente)



usuarios <- rbind(usuarios_2021,
                  usuarios_2022,
                  usuarios_2023,
                  usuarios_2024,
                  usuarios_2020,
                  usuarios_2019,
                  usuarios_2018,
                  usuarios_2017,
                  usuarios_2016,
                  usuarios_2015)

usuarios_2 <- usuarios %>% arrange(id_usuario,-anio) %>% 
  distinct(id_usuario, .keep_all = TRUE)


usuarios_final <- usuarios_2 %>% 
  mutate(id_genero=case_when(genero_usuario=="FEMALE"~1,
                             genero_usuario=="MALE"~2,
                             genero_usuario=="OTHER"~3)) 


# Se guarda el CSV

write.csv(usuarios_final,"insumos/usuarios.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")


# Se guarda una muestra de 1000 casos
# 
# write.csv(usuarios_final[1:1000,],"insumos/usuarios_sample.csv",
#           row.names = FALSE,
#           na="",
#           fileEncoding = "Latin1")

# 
# usuarios_sample <- read.csv("insumos/usuarios_sample.csv")
# 
# 
# writexl::write_xlsx(usuarios_sample,"insumos/usuarios_sample.xlsx")


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
         id_modelo=sample(1:2, size = n(), replace = TRUE),
         id_precio=id_mes) %>% 
  select(id_recorrido,id_usuario,id_estacion_orig=id_estacion_origen,
         id_mes,fecha_origen=fecha_origen_recorrido,
         id_estacion_dest=id_estacion_destino,
         fecha_dest=fecha_destino_recorrido,id_modelo,calificacion,id_precio)



# Se guarda el CSV

write.csv(recorridos_final,"insumos/recorridos.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")

# 
# recorridos_final <- read.csv("insumos/recorridos_sample.csv")
# 
# # Se guarda una muestra de 1000 casos
# 
# write.csv(recorridos_final[1:100,],"insumos/recorridos_sample.csv",
#           row.names = FALSE,
#           na="",
#           fileEncoding = "Latin1")
# 
# 
# writexl::write_xlsx(recorridos_final,"insumos/recorridos_sample.xlsx")
# 
# x <- recorridos_final %>% 
#   group_by(id_usuario) %>% 
#   summarise(casos=n())
# 
# writexl::write_xlsx(x,"insumos/listado_usuarios_borrar.xlsx")


# filtro de la base de usuarios:

rm(url)


#### POR AHORA NO SE USA A PARTIR DE ACÁ ####

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
  select(id_estacion,nombre,direccion,id_barrio,latitud,longitud) %>% 
  mutate(latitud=round(latitud,6),
         longitud=round(longitud,6))

rm(estaciones,estaciones_2)

# Se guarda el CSV


write.csv(estaciones_final,"insumos/estaciones.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")

rm(estaciones_final)





