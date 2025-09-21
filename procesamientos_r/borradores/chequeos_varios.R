chequeo <- read.csv(file = "insumos/bases_finales/chequeo.csv")

chequeo <- chequeo %>% 
  select(id_usuario) %>% 
  mutate(filtro=1)



x <- left_join(usuarios_sample,chequeo)


x2 <- x %>% filter(is.na(filtro))


class(x2$hora_alta)


x2 <- x2 %>%
  mutate(
    hora_alta = as.POSIXct(hora_alta, format="%I:%M:%S %p")
  )

#### Para recorridos


chequeo <- read.csv2(file = "insumos/bases_finales/chequeo.csv")


chequeo <- chequeo %>% 
  select(id_recorrido) %>% 
  mutate(filtro=1)



x <- left_join(recorridos_sample,chequeo)


x2 <- x %>% filter(is.na(filtro))

# Hipótesis: registros fuera de rango:; o duplicados???

table()
