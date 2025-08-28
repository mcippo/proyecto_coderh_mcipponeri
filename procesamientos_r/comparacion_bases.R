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

recorridos_final <- read.csv("insumos/recorridos.csv")


usuarios_final <- read.csv("insumos/usuarios.csv")


#### Chequeo de id usuarios y recorridos ####

names(recorridos_final)

# Usuarios por recorrido:

usarios_recorridos <- recorridos_final %>% 
  group_by(id_usuario) %>% 
  summarise(casos=n())


# Usuarios por usuarios:

usarios_usuarios <- usuarios_final %>% 
  group_by(id_usuario) %>% 
  summarise(casos_usuarios=n())

# Se unen las tablas para ver qué quedó sin usuarios:

compa <- left_join(usarios_recorridos,usarios_usuarios) %>% 
  mutate(casos_usuarios=case_when(casos_usuarios==1~"asignado",
                                  TRUE~"sin asignar"))

table(compa$casos_usuarios)


# Aca hay que buscar la manera de eliminar los id que quedaron sin asignar y ya