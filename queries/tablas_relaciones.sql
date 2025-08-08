-- Se genera la base de datos

drop database ecobici;

CREATE DATABASE IF NOT EXISTS ecobici;

USE ecobici;

-- Tabla género:

CREATE TABLE IF NOT EXISTS genero(
id_genero INT PRIMARY KEY NOT NULL,
genero_usuario VARCHAR (10));

INSERT INTO genero(id_genero,genero_usuario) VALUES
	(1,"femenino"),
    (2,"masculino"),
    (3,"otros");

SELECT * FROM genero;

-- Se genera la variable USUARIOS:

CREATE TABLE IF NOT EXISTS usuarios(
id_usuario INT PRIMARY KEY NOT NULL,
id_genero INT  NOT NULL,
        FOREIGN KEY (id_genero)
        REFERENCES genero(id_genero),
edad_usuario INT NOT NULL,
fecha_alta DATE NOT NULL,
hora_alta TIME);

-- COMUNA:

CREATE TABLE IF NOT EXISTS comuna(
id_comuna INT PRIMARY KEY NOT NULL,
nombre_comuna VARCHAR (10) NOT NULL);


-- BARRIO

CREATE TABLE IF NOT EXISTS barrio(
id_barrio INT PRIMARY KEY NOT NULL,
nombre_barrio VARCHAR (40)  NOT NULL,
id_comuna INT NOT NULL,
        FOREIGN KEY (id_comuna)
        REFERENCES comuna(id_comuna),
poblacion INT NOT NULL,
poblacion_fem INT NOT NULL,
poblacion_masc INT NOT NULL
);

-- Se genera la tabla estaciones de ecobici

CREATE TABLE IF NOT EXISTS estaciones(
id_estacion INT PRIMARY KEY NOT NULL,
nombre VARCHAR (40)  NOT NULL,
direccion VARCHAR (60)  NOT NULL,
id_barrio INT NOT NULL,
        FOREIGN KEY (id_barrio)
        REFERENCES barrio(id_barrio),
long_estacion DECIMAL(9,6),
lat_estacion DECIMAL(9,6));

-- Modelo de bicicleta utilizada:

CREATE TABLE IF NOT EXISTS modelo(
id_modelo INT PRIMARY KEY NOT NULL,
modelo VARCHAR (10));

INSERT INTO modelo(id_modelo,modelo) VALUES
	(1,"fit"),
    (2,"iconic");

 -- Se genera la tabla meses:
  
CREATE TABLE IF NOT EXISTS meses(
id_mes INT PRIMARY KEY NOT NULL,
mes VARCHAR (15));

INSERT INTO meses(id_mes,mes) VALUES
	(1,"Enero"),
    (2,"Febrero"),
    (3,"Marzo"),
    (4,"Abril"),
    (5,"Mayo"),
    (6,"Junio"),
    (7,"Julio"),
    (8,"Agosto"),
    (9,"Septiembre"),
    (10,"Octubre"),
    (11,"Noviembre"),
    (12,"Diciembre");
 
 SELECT * FROM meses;
 
 -- Se genera la tabla con el listado de precios por mes (cada id de precios corresponde a un mes 1=enero,2=febrero...):
  
CREATE TABLE IF NOT EXISTS precios(
id_precio INT PRIMARY KEY NOT NULL,
precio INT NOT NULL);

INSERT INTO precios(id_precio,precio) VALUES
	(1,300),
    (2,400),
    (3,500),
    (4,600),
    (5,700),
    (6,800),
    (7,900),
    (8,1000),
    (9,1100),
    (10,1200),
    (11,1300),
    (12,1400);
 
 SELECT * FROM precios;

-- Se genera una primera tabla la tabla con las relaciones (acá sacar el x):

CREATE TABLE IF NOT EXISTS recorridos (
	id_recorrido INT PRIMARY KEY NOT NULL,
	idx_usuario INT NOT NULL,
	idx_estacion_orig INT NOT NULL,
  idx_mes INT NOT NULL,
  fecha_origen DATETIME DEFAULT CURRENT_TIMESTAMP,
  idx_estacion_dest INT NOT NULL,
  fecha_dest DATETIME DEFAULT CURRENT_TIMESTAMP,
  idx_modelo INT NOT NULL,
  calificacion INT NOT NULL,
  idx_precio INT NOT NULL,
    FOREIGN KEY (idx_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (idx_estacion_orig) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (idx_mes) REFERENCES meses(id_mes),
    FOREIGN KEY (idx_estacion_dest) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (idx_modelo) REFERENCES modelo(id_modelo),
    FOREIGN KEY (idx_precio) REFERENCES precios(id_precio)
);

SELECT * FROM recorridos;

