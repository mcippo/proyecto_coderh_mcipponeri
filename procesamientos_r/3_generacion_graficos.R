#### Se cargan las librerías ####

library(dplyr)
library(tidyverse)
library(janitor)
library(ggplot2)


#### Usuarios según género ####

insumo <- read.csv("resultados/usuarios_edad.csv") %>% 
  mutate(dist=prop.table(cantidad_usuarios))

ggplot(insumo%>%
         mutate(genero=factor(genero,levels = c("otros","femenino","masculino"))))+
  geom_col(aes(x=genero,y=dist,fill=genero))+
  geom_label(aes(x=genero,y=dist,label=paste0(round(dist*100,1),"%"),vjust=-.1))+
  coord_flip()+
  labs(title = "Distribución de los usuarios según género",
       subtitle = "ECOBICI; año 2024",
       x = "",
       y = "",
       caption = "Fuente: Elaboración propia en base a Datos Abiertos GCBA")+
  scale_fill_discrete()+
  theme(panel.grid = element_blank(),
        legend.title = element_blank(),
        legend.position = "none",
        text = element_text(family = "Encode Sans Normal",face="bold",size=11),
        plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "#636363"),
        plot.caption=element_text(face = "bold",hjust=0),
        axis.title = element_blank(),
        axis.text.y=element_text(size=11,face = "bold"),
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        strip.text = element_text(face = "bold", color = "white", hjust = 0),
        strip.background = element_rect(fill = "white", linetype = "solid",
                                        color = "grey", linewidth = 1))
  
  
ggsave("3ra_entrega_final/graf1.png",width = 9, height = 6)



#### Usuarios según edad ####

insumo <- read.csv("resultados/dist_edad.csv")

ggplot(insumo%>%
         mutate(grupo_etario=factor(grupo_etario,
                                    levels = c("entre 18 y 25",
                                               "entre 26 y 35",
                                               "entre 36 y 50",
                                               "entre 51 y 64",
                                               "65 o mas"))))+
  geom_col(aes(x=grupo_etario,y=porcentaje,fill=grupo_etario))+
  geom_label(aes(x=grupo_etario,y=porcentaje,label=paste0(round(porcentaje,1),"%"),
                 vjust=0.5,hjust = -0.1))+
  coord_flip()+
  labs(title = "Distribución de los usuarios según grupo etario",
       subtitle = "ECOBICI; año 2024",
       x = "",
       y = "",
       caption = "Fuente: Elaboración propia en base a Datos Abiertos GCBA")+
  scale_fill_discrete()+
  theme(panel.grid = element_blank(),
        legend.title = element_blank(),
        legend.position = "none",
        text = element_text(family = "Encode Sans Normal",face="bold",size=12),
        plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "#636363"),
        plot.caption=element_text(face = "bold",hjust=0),
        axis.title = element_blank(),
        axis.text.y=element_text(size=14,face = "bold"),
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        strip.text = element_text(face = "bold", color = "white", hjust = 0),
        strip.background = element_rect(fill = "white", linetype = "solid",
                                        color = "grey", linewidth = 1))+
  scale_y_continuous(limits = c(0,50))


ggsave("3ra_entrega_final/graf2.png",width = 10, height = 6)


# Top 20 de recorridos por estacion

insumo <- read.csv("resultados/recorridos_por_estacion.csv") %>% 
  slice(1:20) %>% 
  mutate(nombre_estacion=str_to_title(nombre_estacion))


ggplot(insumo, aes(x = reorder(nombre_estacion, cantidad_recorridos),
                         y = cantidad_recorridos)) +
  geom_col(fill = "#e6550d") +
  geom_label(aes(label = cantidad_recorridos),
             vjust = 0.5, hjust = -0.1, fill = "white") +
  labs(
    title = "Principales 20 estaciones según cantidad de recorridos",
    subtitle = "ECOBICI; año 2024",
    x = "",
    y = "",
    caption = "Fuente: Elaboración propia en base a Datos Abiertos GCBA"
  ) +
  coord_flip() +  # Hacemos el gráfico horizontal
  theme(
    panel.grid = element_blank(),
    legend.position = "none",
    text = element_text(family = "Encode Sans Normal", face = "bold", size = 12),
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(color = "#636363"),
    plot.caption = element_text(face = "bold", hjust = 0),
    axis.text.y = element_text(size = 10, face = "bold"),
    axis.ticks = element_blank(),
    axis.text.x = element_blank(),
    strip.text = element_text(face = "bold", color = "white", hjust = 0),
    strip.background = element_rect(fill = "white", linetype = "solid",
                                    color = "grey", linewidth = 1)
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)))

ggsave("3ra_entrega_final/graf3.png",width = 10, height = 6)
