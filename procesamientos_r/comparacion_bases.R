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


usuarios <- read.csv("insumos/usuarios.csv")

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

# Se guarda el sample de los recorridos


write.csv(recorridos_sample,"insumos/bases_finales/recorridos_sample.csv",
          row.names = FALSE,
          na="",
          fileEncoding = "Latin1")





