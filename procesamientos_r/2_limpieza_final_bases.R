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


# Comparación base usuarios y recorridos:

recorridos <- read.csv("insumos/recorridos.csv") 

# Chequeos de NA:

sum(is.na(recorridos$id_recorrido))
sum(is.na(recorridos$id_usuario))
sum(is.na(recorridos$id_estacion_orig))
sum(is.na(recorridos$id_mes))
sum(is.na(recorridos$fecha_origen))
sum(is.na(recorridos$id_estacion_dest))
sum(is.na(recorridos$fecha_dest))
sum(is.na(recorridos$id_modelo))
sum(is.na(recorridos$calificacion))
sum(is.na(recorridos$id_precio))


# Usuarios:

usuarios <- read.csv("insumos/usuarios.csv") %>% 
  select(id_usuario,id_genero,edad_usuario,fecha_alta,hora_alta)

# Chequeo de NA

sum(is.na(usuarios$id_usuario))
sum(is.na(usuarios$id_genero))
sum(is.na(usuarios$edad_usuario))
sum(is.na(usuarios$fecha_alta))
sum(is.na(usuarios$hora_alta))

# Correción de NAs en id_genero


table(usuarios$id_genero)

usuarios <- usuarios %>% 
  mutate(id_genero=ifelse(is.na(id_genero),3,id_genero))

table(usuarios$id_genero)

sum(is.na(usuarios$id_genero))

# Para ver cuántos casos tiene AM PM en la hora de alta:

chequeo <- usuarios %>%
  filter(str_detect(hora_alta, "AM|PM"))

# Corrección hora:

usuarios <- usuarios %>%
  mutate(hora_alta = sub(" ?(AM|PM)$", "", hora_alta, ignore.case = TRUE))

# Esto tiene que dar 0:


chequeo <- usuarios %>%
  filter(str_detect(hora_alta, "AM|PM"))

rm(chequeo)

# Se comienza con los macheos


lista_usuarios <- usuarios %>% select(id_usuario) %>% 
  mutate(asigna=1)

# Se le asigna un usuario a los recorridos:

recorridos_final <- left_join(recorridos,lista_usuarios)


# Se limpian los recorridos sin usuarios asignados:

recorridos_final <- recorridos_final %>% 
  filter(asigna==1) %>% 
  select(-asigna)


x <- recorridos_final[1:10,]

# Se guarda la base:


write.csv(recorridos_final,"insumos/bases_finales/recorridos.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")


#### Nos quedamos con los usuarios que realizaron recorridos en 2024 ####


usuarios_recorridos <- recorridos_final %>% 
  group_by(id_usuario) %>% 
  summarise(filtro=1)


usuarios_final <- left_join(usuarios,usuarios_recorridos) %>% 
  filter(filtro==1) %>% 
  select(-filtro)


# Se guarda la lista de usuarios final:

write.csv(usuarios_final,"insumos/bases_finales/usuarios.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")


#### SE GENERA UNA BASE DE 1000 usuarios ####




usuarios <- read.csv("insumos/bases_finales/usuarios.csv")

usuarios_sample <- usuarios[sample(nrow(usuarios), 500), ]


write.csv(usuarios_sample,"insumos/bases_finales/usuarios_sample.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")



lista <- usuarios_sample %>%
  mutate(filtro=1) %>%
  select(id_usuario,filtro)
  

recorridos <- read.csv("insumos/bases_finales/recorridos.csv")


recorridos_sample <- left_join(recorridos,lista)

# Se filtran los casos a los que se les asignó un usuario de las lista sample


recorridos_sample <- recorridos_sample %>% 
  filter(filtro==1)


table(recorridos_sample$filtro)

recorridos_sample <- recorridos_sample %>%
  select(-filtro)

# Se guarda el sample de los recorridos


write.csv(recorridos_sample,"insumos/bases_finales/recorridos_sample.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")





