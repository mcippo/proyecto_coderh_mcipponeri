-- relaciones entre tablas:

CREATE TABLE IF NOT EXISTS barrio (
    id_barrio INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre_barrio VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS estaciones (
    id_estacion INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    direccion VARCHAR(60) NOT NULL,
    id_barrio INT NOT NULL,
        FOREIGN KEY (id_barrio)
        REFERENCES barrio(id_barrio)
);

DROP TABLE estaciones;
DROP TABLE barrio;

SELECT * FROM estaciones;