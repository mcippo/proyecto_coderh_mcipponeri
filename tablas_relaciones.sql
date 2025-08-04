-- Se genera la base de datos

CREATE DATABASE IF NOT EXISTS ecobici;

USE ecobici;


-- Se genera la base de usuarios de ecobici

CREATE TABLE IF NOT EXISTS usuarios(
id_usuario INT PRIMARY KEY NOT NULL,
genero_usuario VARCHAR (10)  NOT NULL,
edad_usuario INT NOT NULL,
fecha_alta DATE NOT NULL,
hora_alta TIME);

-- Se genera la tabla estaciones de ecobici

CREATE TABLE IF NOT EXISTS estaciones(
id_estacion INT PRIMARY KEY NOT NULL,
nombre VARCHAR (40)  NOT NULL,
direccion VARCHAR (60)  NOT NULL,
id_barrio INT NOT NULL,
id_comuna INT NOT NULL,
long_estacion DECIMAL(9,6),
lat_estacion DECIMAL(9,6));

-- Se genera la tabla barrio (se suma la variable población, que no está en la tabla original):

CREATE TABLE IF NOT EXISTS barrio(
id_barrio INT PRIMARY KEY NOT NULL,
nombre_barrio VARCHAR (40)  NOT NULL,
id_comuna INT NOT NULL,
poblacion INT NOT NULL);

-- Se genera la variable comuna

CREATE TABLE IF NOT EXISTS comuna(
id_comuna INT PRIMARY KEY NOT NULL,
nombre_comuna VARCHAR (40)  NOT NULL);

-- Se genera la tabla de modelo de la bicicleta

CREATE TABLE IF NOT EXISTS modelo(
id_bici INT PRIMARY KEY NOT NULL,
nombre_modelo VARCHAR (10)  NOT NULL);


-- Se genera una primera tabla la tabla con las relaciones:

CREATE TABLE IF NOT EXISTS recorridos (
	idx_usuario INT,
	idx_estacion INT,
    idx_barrio INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,    
    PRIMARY KEY (idx_usuario, idx_estacion,idx_barrio),
    FOREIGN KEY (idx_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (idx_estacion) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (idx_barrio) REFERENCES barrio(id_barrio)
);

DROP TABLE recorridos;

-- ver de utilizar un código de estaciones y tablas con los nombres de las estaciones y asignar códigos

-- la distancia se va a generar con la función point


