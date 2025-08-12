# SISTEMA DE ECOBICI EN CABA: Funcionamiento y Mejoras Potenciales

**CURSO:** _SQL FLEX_

**COMISIÓN:** _81830_

**DOCENTE:** _Alejandro Di Stefano_

**ALUMNO:** _Mariano Cipponeri_


## Índice

- [Introducción](#introducción)
- [Objetivos](#objetivos)
- [Primeras tablas](#primeras-tablas)
- [Resultados esperados](#resultados-esperados)

## Introducción

El servicio de _ECOBICIS_ es un sistema de bicicletas públicas ofrecidas por el Gobierno de la Ciudad de Buenos Aires **(GCBA)** que funciona desde el año 2010.

Desde el momento en que comenzó a funcionar el sistema, el mismo fue presentando mutaciones en diferentes aspectos:
  
  - Se pasó de un sistema de manual y presencial a uno completamente automatizado (en la actualidad el retiro de las bicletas requiere de la utilización de la app de Ecobici).
  
  - Se fue aumentando el stock y las prestaciones de las bicicletas (hoy en día todas poseen GPS)
  
  - En 2018 se concecionó el servicio, siendo la empresa brasilera **TEAMBICI** la que ganó la licitación (y la ostenta hasta la actualidad).
  
  - Finalmente, uno de los cambios más relevantes se produjo en 2020, cuando se aranceló parcialmente el servicio, teniendo que pagar los no residentes un importe por la utilización de las bicicletas.


Si bien el servicio de _ECOBICI_ viene demostrando un exitoso desempeño (si se toma como parámetro la evolución de unidades y estaciones disponibles, los usuarios y viajes realizados), tanto desde el GCBA como desde TEAMBICI se busca realizar modificaciones en el servicio, en pos de mejorar la experiencia para los usuarios, incrementar la penetración del servicio y mejorar los márgenes de ganancia del Gobierno y la empresa a cargo de la concesion.

Establecido dicho norte, se buscará realizar un estudio que de cuenta tanto del volumen de la utilización de ECOBICI, como del perfil de los usuarios/viajes realizados. Esto permitirá llevar a cabo acciones orientadas a satisfacer los objetivos planteados en el párrafo anterior.

Si bien este trabajo **parte de una situación hipotética**, los principales insumos prevendrán de bases de datos de ECOBICI en el sitio de [datos abiertos del GCBA](https://data.buenosaires.gob.ar/).

El grueso de los campos y registros procesados provendrán de las bases del dataset de datos abiertos GCBA, sin embargo, se incluirán campos ficticios, con el fin de poder profundizar el uso de SQL. Cuando esto suceda, será debidamente aclarado.

## Objetivos

A través del uso del herramental ofrecido por SQL en las bases de datos mencionadas, se buscará:

 * Describir el perfil de los usuarios de ECOBICI (sexo, edad, con la posibilidad de incluir el campo _residencia_).
 
 * Calcular el volumen de usuarios / recorridos realizados y su evolución en el tiempo
 
 * Caracterizar los recorridos realizados (barrio y estación de origen, momento en el que se realizó el viaje, duración temporal, distancia recorrida).
 
 * Evaluar las calificaciones otorgadas al recorrido realizado (el campo de calificación del viaje será ficticio), de manera tal de buscar relaciones entre la calificación y variables como: modelo de bicicleta utilizado o estacíon de origen.
 
 * Relacionar perfiles de usuario con el volumen de uso de ECOBICI, con el fin de desarrollar estrategías de penetración del servicio.
 
 * Estimar cuál habría sido el volumen de ingresos generados por la ECOBICI en caso de haber sido un servicio tarifado para toda la población en 2024.

## Primeras tablas

## Tablas a presentar en la primera entrega

En esta primera entrega, se generaran las siguientes tablas:

 **GENERO:** 

Esta tabla se utilizará para etiquetar al campo _genero_ en las futuras consultas. Se establece como Primary Key _id_genero_ y se relacionará con el _id_genero_ de la tabla **usuarios.**


| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del genero | id_genero | INT | PK|
| genero  | genero_usuario | VARCHAR (10) | -      |


 **USUARIOS:** 

Esta tabla se utilizará para aportar información del usuario en la tabla de **recorridos**, se vinculará a través de la primary key _id_usuario_.

| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del usuario | id_usuario | INT | PK|
| id del genero  | genero_usuario | INT | FK      |
| edad  | edad_usuario | INT  | -      |
| fecha de inscripción en ECOBICI  | fecha_alta | DATE | -      |
| hora de la fecha del alta  | hora_alta | TIME | -      |


 **COMUNA:** 

Esta tabla se utilizará para etiquetar al campo _comuna_ en las futuras consultas. Se establece como Primary Key _id_comuna_ y se relacionará con el _id_comuna_ de la tabla **barrios.**


| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  de la comuna | id_comuna | INT | PK|
| nombre de la comuna  | nombre_comuna | VARCHAR (10) |  -     |


 **BARRIO:** 

Esta tabla se utilizará para etiquetar al campo _barrio_ y aportar información de los barrios en las futuras consultas. Se establece como Primary Key _id_barrio_ y se relacionará con el _id_barrio_ de la tabla **recorridos.**

| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del barrio | id_barrio | INT | PK|
| nombre del barrio  | nombre_barrio | VARCHAR (40) | - | 
| id  de la comuna  | id_comuna | INT |  FK     |
| cantidad de habitantes del barrio  | poblacion | INT |  -     |
| cantidad de habitantes mujeres del barrio  | poblacion_fem | INT |  -     |
| cantidad de habitantes varones del barrio  | poblacion_masc | INT |  -     |


 **ESTACIONES:** 

Esta tabla se utilizará para etiquetar al campo _estacion_ en las futuras consultas y para aportar información de las estaciones. Se establece como Primary Key _id_estacion_ y se relacionará con el _id_estacion_ de la tabla **recorridos.**

| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  de la estacion de bici | id_estacion | INT | PK|
| nombre de la estación  | nombre | VARCHAR (40) | - | 
| dirección de la estación  | direccion | VARCHAR (60) | - |
| id del barrio  | id_barrio | INT |  FK     |
| latitud de la estación  | latitud | DECIMAL(9,6) |  - |
| longitud de la estación  | longitud | DECIMAL(9,6)  | - |

 **MODELO:** 

Esta tabla se utilizará para etiquetar al campo _modelo_ (de la bicicleta) en las futuras consultas. Se establece como Primary Key _id_modelo_ y se relacionará con el _id_modelo_ de la tabla **recorridos.**

| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del modelo de la bici | id_modelo | INT | PK |
| nombre del modelo de la bici  | modelo | VARCHAR (10) | - | 


 **MESES:** 

Esta tabla se utilizará para etiquetar al campo _mes_ en las futuras consultas. Se establece como Primary Key _id_mes_ y se relacionará con el _id_mes_ de la tabla **recorridos.**


| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del mes | id_mes | INT | PK |
| nombre del mes del año  | mes | VARCHAR (15) | - | 


 **PRECIOS:** 


Esta tabla se utilizará para etiquetar al campo _precio_ en las futuras consultas. Se establece como Primary Key _id_mes_ y se relacionará con el _id_mes_ de la tabla **recorridos.**


| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del precio | id_precio | INT | PK |
| precio sugerido por el cobro del servicio  | precio | INT | - | 


 **RECORRIDOS:** 

Esta tabla aportará información del _recorrido_, relacionándose con las tablas anteriormente descritas.


| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del recorrido realizado | id_recorrido | INT AUTO INCREASE | PK|
| id del usuario  | id_usuario | INT | FK | 
| id de la estacion de origen  | id_estacion_orig | INT |  FK     |
| id del mes en que se produce el recorrido  | id_mes | INT |  FK     |
| fecha en que se retira la bici  | fecha_origen | DATETIME |  -     |
| id de la estacion de destino  | id_estacion_dest | INT |  FK     |
| fecha y hora en que se produce el retiro  | fecha_dest | DATETIME | -     |
| id del modelo de la bici utilizada  | id_modelo | INT | FK     |
| calificación de la experiencia de uso de la bici  | calificacion | INT | -  |
| id del precio que se debería haber pagado por la bici  | id_precio | INT | FK |


## Resultados esperados

A través de la utilización de las bases mencionadas, a priori (ya que a futuro se irán modificando los objetivos o sumando nuevas propuestas), se espera realizar vía SQL las siguientes consultas / vistas:

 * Cantidad de usuarios por sexo
 * Cantidad de usuarios por edad
 * Recorridos por sexo
 * Recorridos por edad
 * Cantidad de recorridos por estación
 * Cantidad de recorridos por barrio
 * Calificación del recorrido por estación
 * Recorridos por tipo de modelo de bicicleta utilizada
 * Calificación promedio otorgada por modelo de bicleta
 * Ingresos que se podrían haber generado por la utilización del servicio por barrio
 * Ingresos que se podrían haber generado por la utilización del servicio por estación
 * Usuarios que hubiesen gastado más en el servicio (se podrá selecciónar a los quintiles más altos)
 * Kilometros recorridos por estación
 * Kilometros por sexo
 * Kilometros por edad
 * Kilometros por estación
 * Minutos de recorrido por estación de origen
 * Minutos de recorrido por sexo
 * Minutos de recorrido por edad
 * Minutos de recorrido por estación de origen
 
**A futuro, se incorporarán consultas que implicarán el cruce de una mayor cantidad de variables**, como por ejemplo cantidad de recorridos por sexo, según estación.
 
 
 
 
