-- Se genera la base de datos

CREATE DATABASE IF NOT EXISTS ecobici;

USE ecobici;


-- Se genera la variable USUARIOS:

CREATE TABLE IF NOT EXISTS usuarios(
id_usuario INT PRIMARY KEY NOT NULL,
genero_usuario VARCHAR (10)  NOT NULL,
edad_usuario INT NOT NULL,
fecha_alta DATE NOT NULL,
hora_alta TIME);


-- BARRIO

CREATE TABLE IF NOT EXISTS barrio(
id_barrio INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre_barrio VARCHAR (40)  NOT NULL,
id_comuna INT NOT NULL,
poblacion INT NOT NULL);


INSERT INTO barrio(nombre_barrio,id_comuna,poblacion) VALUES
	("Boedo",4,100000),
    ("Palermo",4,100000);

SELECT * FROM barrio;

-- Se genera la tabla estaciones de ecobici

CREATE TABLE IF NOT EXISTS estaciones(
id_estacion INT NOT NULL,
nombre VARCHAR (40)  NOT NULL,
direccion VARCHAR (60)  NOT NULL,
id_barrio INT NOT NULL,
id_comuna INT NOT NULL,
long_estacion DECIMAL(9,6),
lat_estacion DECIMAL(9,6));

DROP TABLE estaciones;

INSERT INTO estaciones(id_estacion,nombre,direccion,id_barrio,id_comuna,long_estacion,lat_estacion) VALUES
	(1,"vidal","Av. Cramer 2900",1,1,-34.55814,-58.46726),
    (2,"RETIRO I","AV. Dr. José María Ramos Mejía 1300",2,3,-34.59242,-58.37471);

SELECT * FROM estaciones;


-- Se genera la tabla barrio (se suma la variable población, que no está en la tabla original):


--  Inserciones dentro de las variables 

-- ver relación entre la población y la cantidad de usuarios de ecobici en por barrio

-- Se genera la tabla de modelo de la bicicleta

CREATE TABLE IF NOT EXISTS modelo(
id_bici INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre_modelo VARCHAR (10)  NOT NULL);

-- Sumar inserciones:

INSERT INTO modelo(nombre_modelo) VALUES
	("fit"),
    ("iconic");

SELECT * FROM modelo;


-- Se genera una primera tabla la tabla con las relaciones:

CREATE TABLE IF NOT EXISTS recorridos (
	id_recorrido INT NOT NULL,
	idx_usuario INT,
	idx_estacion INT,
    idx_barrio INT,
    idx_modelo INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP, 
    cord_partida POINT,
    cord_llegada POINT,
    PRIMARY KEY (idx_usuario, idx_estacion,idx_barrio),
    FOREIGN KEY (idx_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (idx_estacion) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (idx_barrio) REFERENCES barrio(id_barrio),
    FOREIGN KEY (idx_modelo) REFERENCES modelo(id_bici)
);

DROP TABLE recorridos;

-- ver de utilizar un código de estaciones y tablas con los nombres de las estaciones y asignar códigos

-- la distancia se va a generar con la función point


