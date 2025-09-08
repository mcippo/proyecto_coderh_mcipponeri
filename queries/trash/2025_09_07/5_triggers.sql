
USE ecobici;

-- TRIGGERS:

-- 1) Se generan triggers para registrar en una tabla de auditoria estaciones incorporadas al sistema:

-- 1a) Trigger para nuevas entradas

-- Se genera la tabla espejo

CREATE TABLE IF NOT EXISTS auditoria_estaciones(
id_estacion INT,
nombre VARCHAR (40),
direccion VARCHAR (60),
fecha_modificacion DATE,
hora_modificacion TIME,
usuario VARCHAR(50),
comentarios VARCHAR(100)); 

-- Se crea el trigger

CREATE TRIGGER tr_auditoria_estaciones
AFTER INSERT ON estaciones
FOR EACH ROW
INSERT INTO auditoria_estaciones
VALUES (NEW.id_estacion,NEW.nombre,NEW.direccion,
CURRENT_DATE, CURRENT_TIME,CURRENT_USER,'Se agrega una nueva estacion');

-- Se prueba la inserción de una nueva estación:

INSERT INTO estaciones (id_estacion, nombre, direccion,
 id_barrio,latitud,longitud) VALUES 
 (597,'RETIRO 2','Suipacha 1114',29,-34.592424,-58.37471);
 
 -- Para ver el resultado en la tabla espejo:
 
 SELECT * FROM auditoria_estaciones;

-- 1b) Ahora se genera un trigger para registrar las estaciones_eliminadas:

-- Se genera el trigger:

drop trigger tr_auditoria_estaciones_eliminadas;

CREATE TRIGGER tr_auditoria_estaciones_eliminadas
BEFORE DELETE ON estaciones
FOR EACH ROW
INSERT INTO auditoria_estaciones
VALUES (OLD.id_estacion,OLD.nombre,OLD.direccion,
CURRENT_DATE, CURRENT_TIME,CURRENT_USER,'Se elimina estacion');

-- Se elimina una estación:

DELETE FROM estaciones WHERE id_estacion=597;

-- Para observar cómo fuciona el trigger (se elimina la estación creada previamente):

SELECT * FROM auditoria_estaciones;

-- 2) Se genera otro trigger para registrar los nuevos usuarios: 

-- 2a) Trigger para registrar los nuevos usuarios: 
 
-- Se genera una tabla de auditoría para registar los nuevos usuarios en la tabla de usuarios


CREATE TABLE IF NOT EXISTS auditoria_usuarios(
id_usuario INT,
id_genero INT,
edad_usuario INT,
fecha_modificacion DATE,
hora_modificacion TIME,
data_entry VARCHAR(50),
comentarios VARCHAR(100)); 

-- Se genera el trigger

CREATE TRIGGER tr_auditoria_usuarios
AFTER INSERT ON usuarios
FOR EACH ROW
INSERT INTO auditoria_usuarios
VALUES (NEW.id_usuario,NEW.id_genero,NEW.edad_usuario,
CURRENT_DATE,CURRENT_TIME,CURRENT_USER,'Se agrega un nuevo usuario');

-- Se inserta un caso para probar 

INSERT INTO usuarios (id_usuario, id_genero, edad_usuario, fecha_alta, hora_alta)
VALUES (2000005, 2, 30, CURRENT_DATE, CURRENT_TIME);

 -- Para ver el resultado en la tabla espejo:

SELECT * FROM auditoria_usuarios;

-- 2b) Trigger para registrar los usuarios dados de baja:

drop trigger tr_auditoria_usuarios_eliminados;

-- Se genera el trigger

CREATE TRIGGER tr_auditoria_usuarios_eliminados
BEFORE DELETE ON usuarios
FOR EACH ROW
INSERT INTO auditoria_usuarios
VALUES (OLD.id_usuario,OLD.id_genero,OLD.edad_usuario,
CURRENT_DATE,CURRENT_TIME,CURRENT_USER,'Se elimina un usuario');

-- Se elimina un usuario (el mismo usuario generado previamente):

DELETE FROM usuarios WHERE id_usuario=2000005;

-- Para observar cómo fuciona el trigger:

SELECT * FROM auditoria_usuarios;
