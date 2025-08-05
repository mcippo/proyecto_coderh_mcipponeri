-- Se genera la base de datos

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
    

-- Se genera una primera tabla la tabla con las relaciones:

CREATE TABLE IF NOT EXISTS recorridos (
	id_recorrido INT PRIMARY KEY NOT NULL,
	idx_usuario INT NOT NULL,
	idx_estacion_orig INT NOT NULL,
    fecha_origen DATETIME DEFAULT CURRENT_TIMESTAMP,
    idx_estacion_dest INT NOT NULL,
    fecha_dest DATETIME DEFAULT CURRENT_TIMESTAMP,
    idx_modelo INT NOT NULL,
    FOREIGN KEY (idx_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (idx_estacion_orig) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (idx_estacion_dest) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (idx_modelo) REFERENCES modelo(id_modelo)
);

