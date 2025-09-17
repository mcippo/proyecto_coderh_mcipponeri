-- Activamos la base

USE ecobici;

-- Desactivamos el autocommit:

SET autocommit=0;

-- Chequeo

SELECT @@autocommit;

-- 1) USO DE COMMIT

--  1a) Para agregar un usuario nuevo utilizando COMMIT	

START TRANSACTION;

INSERT INTO usuarios (id_usuario, id_genero, edad_usuario, fecha_alta, hora_alta)
VALUES (2000006, 2, 30, CURRENT_DATE, CURRENT_TIME);

COMMIT;

-- chequeo (tiene que figurar el caso generado)

SELECT id_usuario, id_genero, edad_usuario, fecha_alta, hora_alta
FROM usuarios
WHERE id_usuario = 2000006;


-- 1b) Para corregir la edad del usuario utilizando COMMIT

START TRANSACTION;

UPDATE usuarios
SET edad_usuario= 32
WHERE id_usuario = 2000006;

COMMIT;

-- 2) USO DE ROLLBACK

-- Se carga una estación ficticia para este ejemplo

START TRANSACTION;

INSERT INTO estaciones (id_estacion, nombre, direccion,
 id_barrio,latitud,longitud) VALUES 
 (600,'RETIRO 4','AV. Dr. José María Ramos Mejía 1300',29,-34.592424,-58.37471);

COMMIT;

-- Un data entry pretende actualizar las bases de datos y por error borra la estación anterior, el rollback anula el delete

select * FROM estaciones;

START TRANSACTION;

DELETE FROM estaciones WHERE id_estacion=600;

rollback;

-- Hecha la prueba del rollback, ahora sí, se elimina la estación generada para el ejemplo:

START TRANSACTION;

DELETE FROM estaciones WHERE id_estacion=600;

COMMIT;

-- Ahora no deberían existir casos en la siguiente tabla

SELECT * FROM estaciones
WHERE id_estacion=600;

-- 3) USO de SAVEPOINT:

-- La empresa concesionaria habilitó la posibilidad para que los usuarios realicen una modificación de la calificación del recorrido, esas modificaciones deben ser modificadas por un data entry

-- Para ver las calificaciones de los dos usuarios que van a ser modificado

SELECT id_recorrido, calificacion FROM recorridos
WHERE id_recorrido IN (20181508,20181679);

-- Comienza la transacción:

START TRANSACTION;

-- Se modifica la calificacion del id 20181508 (pasa de 9 a 6)

UPDATE recorridos SET calificacion=6
WHERE id_recorrido=20181508;

-- Se genera el savepoint para recuperar las modificaciones hasta este punto

SAVEPOINT actualizacion;

-- Se modifica la calificacion del id 20181508 (pasa de 3 a 7)

UPDATE recorridos SET calificacion=7
WHERE id_recorrido=20181679;

-- Se revierte el último update:

ROLLBACK TO actualizacion;

-- Se confirman los cambios:

COMMIT;

-- Se chequea que el primer caso haya quedado con una calificación de 6 y el segundo de 3 (el valor original)

SELECT id_recorrido, calificacion FROM recorridos
WHERE id_recorrido IN (20181508,20181679);

-- Volvemos a activar el autocommit:

SET autocommit = 1;

-- Chequeo

SELECT @@autocommit;


