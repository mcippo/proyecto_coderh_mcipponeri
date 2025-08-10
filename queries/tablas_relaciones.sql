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

-- Se genera la variable USUARIOS (las tablas se van a importar desde el csv descargado de la página de GCBA procesadas en R):

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

-- Se cargan registros en la tabla comuna:

INSERT INTO comuna(id_comuna,nombre_comuna) VALUES
	(1,"Comuna 1"),
    (2,"Comuna 2"),
    (3,"Comuna 3"),
    (4,"Comuna 4"),
    (5,"Comuna 5"),
    (6,"Comuna 6"),
    (7,"Comuna 7"),
    (8,"Comuna 8"),
    (9,"Comuna 9"),
    (10,"Comuna 10"),
    (11,"Comuna 11"),
    (12,"Comuna 12"),
    (13,"Comuna 13"),
    (14,"Comuna 14"),
    (15,"Comuna 15");

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

-- Se generan los registros de la tabla barrio:


INSERT INTO barrio (id_barrio, nombre_barrio, id_comuna, poblacion,
 poblacion_fem, poblacion_masc) VALUES
(1,'Agronomia',15,13963,7493,6470),
(2,'Almagro',5,128206,71821,56385),
(3,'Balvanera',3,137521,76332,61189),
(4,'Barracas',4,73377,39030,34347),
(5,'Belgrano',13,126816,70731,56085),
(6,'Boedo',5,45563,24556,21007),
(7,'Caballito',6,170309,95110,75199),
(8,'Chacarita',15,25778,13763,12015),
(9,'Coghlan',12,18021,9788,8233),
(10,'Colegiales',13,52391,29412,22979),
(11,'Constitucion',1,41894,22885,19009),
(12,'Flores',7,142695,77593,65102),
(13,'Floresta',10,37247,20341,16906),
(14,'Boca',4,43413,23007,20406),
(15,'Paternal',15,19058,10123,8935),
(16,'Liniers',9,42083,22949,19134),
(17,'Mataderos',9,62206,33472,28734),
(18,'Monserrat',1,39175,21270,17905),
(19,'Monte Castro',10,32782,17602,15180),
(20,'Nueva Pompeya',4,60465,31547,28918),
(21,'Nuñez',13,49019,26830,22189),
(22,'Palermo',14,225245,126030,99215),
(23,'Parque Avellaneda',9,51678,27462,24216),
(24,'Parque Chacabuco',7,54638,29426,25212),
(25,'Parque Chas',15,18926,10142,8784),
(26,'Parque Patricios',4,37791,20535,17256),
(27,'Puerto Madero',1,406,185,221),
(28,'Recoleta',2,165494,95391,70103),
(29,'Retiro',1,38635,21484,17151),
(30,'Saavedra',12,48956,26380,22576),
(31,'San Cristobal',3,46494,25622,20872),
(32,'San Nicolas',1,28667,15450,13217),
(33,'San Telmo',1,23198,12470,10728),
(34,'Velez Sarsfield',10,34084,18580,15504),
(35,'Versalles',10,13556,7249,6307),
(36,'Villa Crespo',15,83646,45614,38032),
(37,'Villa Del Parque',11,55502,30326,25176),
(38,'Villa Devoto',11,67712,35681,32031),
(39,'Villa Gral. Mitre',11,34204,18519,15685),
(40,'Villa Lugano',8,108170,56666,51504),
(41,'Villa Luro',10,31859,17070,14789),
(42,'Villa Ortuzar',15,21256,11573,9683),
(43,'Villa Pueyrredon',12,38558,20806,17752),
(44,'Villa Real',10,13681,7313,6368),
(45,'Villa Riachuelo',8,13995,7525,6470),
(46,'Villa Santa Rita',11,32248,17469,14779),
(47,'Villa Soldati',8,39477,20374,19103),
(48,'Villa Urquiza',12,85587,46498,39089);

SELECT * FROM barrio;

-- Se genera la tabla estaciones de ecobici (se genera en R, se van a importar los registros en el csv a futuro)

CREATE TABLE IF NOT EXISTS estaciones(
id_estacion INT PRIMARY KEY NOT NULL,
nombre VARCHAR (40)  NOT NULL,
direccion VARCHAR (60)  NOT NULL,
id_barrio INT NOT NULL,
        FOREIGN KEY (id_barrio)
        REFERENCES barrio(id_barrio),
latitud DECIMAL(9,6),
longitud DECIMAL(9,6));

-- Modelo de bicicleta utilizada :

CREATE TABLE IF NOT EXISTS modelo(
id_modelo INT PRIMARY KEY NOT NULL,
modelo VARCHAR (10));

-- Se insertan los valores

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
 
-- Se genera una primera tabla la tabla con las relaciones (acá sacar el x):

CREATE TABLE IF NOT EXISTS recorridos (
	id_recorrido INT PRIMARY KEY NOT NULL,
	id_usuario INT NOT NULL,
	id_estacion_orig INT NOT NULL,
  id_mes INT NOT NULL,
  fecha_origen DATETIME,
  id_estacion_dest INT NOT NULL,
  fecha_dest DATETIME,
  id_modelo INT NOT NULL,
  calificacion INT NOT NULL,
  id_precio INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_estacion_orig) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (id_mes) REFERENCES meses(id_mes),
    FOREIGN KEY (id_estacion_dest) REFERENCES estaciones(id_estacion),
    FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
    FOREIGN KEY (id_precio) REFERENCES precios(id_precio)
);

