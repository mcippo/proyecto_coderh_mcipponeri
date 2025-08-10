
library(dplyr)


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
