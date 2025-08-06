# ECOBICIS EN CABA: PRINCIPALES CARACTERÍSTICAS Y POTENCIALES MEJORAS

## Índice

- [Introducción](#introducción)
- [Objetivos](#objetivos)
- [Metodología](#metodología)

## Introducción

El servicio de _ECOBICIS_ es un sistema de bicicletas públicas ofrecidas por el Gobierno de la Ciudad de Buenos Aires **(GCBA)** que funciona desde el año 2010.

Desde que el momento en que se comenzó a ofrecer el servicio, el mismo fue presentando mutaciones en diferentes dimensiones:
  
  - Se pasó de un sistema de manual y presencial a uno completamente automatizado (en la actualidad el retiro de las bicletas requieren la utilización de la app de Ecobici).
  
  - Se fue mejorando el stock de bicicletas (hoy en día todas poseen GPS)
  
  - En 2018 se consecionó el servicio, siendo la empresa brasilera **TEAMBICI** la que obtuvo la concesión y la que la ostenta hasta el día de la fecha.
  - Finalmente, el cambio más relevante se produjo en 2020, cuando se aranceló parcialmente el servicio, teniendo que pagar un importe por la utilización del servicio los no residentes en el país.


Si bien el servicio de ECOBICI viene demostrando un exitoso desempeño (si se toma como parámetros la evolución de unidades y estaciones disponibles, los usuarios y viajes realizados), tanto desde el GCBA como desde TEAMBICI se busca realizar modificaciones en el servicio, en pos de mejorar la experiencia para los usuarios a la vez que se mejoran los márgenes de ganancia del Gobierno y la empresa a cargo de la conseción.

Establecido dicho norte, se buscará realizar un estudio que de cuenta tanto del volumen de la utilización de ECOBICI como del perfil de los usuarios/viajes realizados. Esto permitirá llevar a cabo acciones orientadas a **aumentar la utilización del servicio y establecer estrategias para su potencial arancelamiento en el futuro.**

Si bien este trabajo parte de una situación hipotética, los principales insumos prevendrán de bases de datos de ECOBICI en el sitio de [datos abiertos del GCBA](https://data.buenosaires.gob.ar/).

El grueso de los campos y registros procesados provendrán de las bases del dataset de datos abiertos GCBA, sin embargo, se incluirán campos ficticios, con el fin de poder profundizar el uso de SQL. Cuando esto suceda, será debidamente aclarada.

## Objetivos

A través del uso del herramental ofrecido por SQL en las bases de datos mencionadas, se buscará:

 * Describir el perfil de los usuarios de ECOBICI (sexo, edad, con la posibilidad de incluir el campo _residencia_).
 
 * Calcular el volumen de usuarios / recorridos realizados y su evolución en el tiempo
 
 * Caracterizar los recorridos realizados (barrio y estación de origen, momento en el que se realizó el viaje, duración temporal, distancia recorrida).
 
 * Evaluar el desempeño de los modelos de ECOBICI ofrecidas (el campo de calificación del viaje será ficticio)

 * Relacionar perfiles de usuario con volumen de uso de ECOBICI, con el fin de desarrollar estrategías de penetración del servicio.
 
 * Estimar el volumen de ingresos generados por la ECOBICI en caso de haber sido un servicio tarifado en 2024.


## Tablas a presentar en la primera entrega:

En esta primera entrega, se generaran las siguientes tablas:

 ** GENERO:** 


| Nombre Campo  | Abreviatura | Tipo de datos | Tipo de clave  |
|:--------------|:-----------:|:-------------:|:--------------:|
| id  del usuario | id_genero | INT PRIMARY KEY NOT NULL| PK|
| genero  | genero_usuario | VARCHAR (10) | -      |




## Metodología



