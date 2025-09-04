-- ejemplo de coder sobre litros de pintura
delimiter $$
CREATE FUNCTION `calcular_litros_de_pintura` (largo INT, alto INT, total_manos INT) 
RETURNS FLOAT
NO SQL
BEGIN
DECLARE resultado FLOAT;
    	DECLARE litro_x_m2 FLOAT;
	SET litro_x_m2 = 0.10;
SET resultado = ((largo * alto) * total_manos) * litro_x_m2;
RETURN resultado;
END$$


-- forma de llamar a la funcion
SELECT calcular_litros_de_pintura(22, 5, 3) AS total_pintura;


-- fUNCIONES DE PRACTICA EN CLASE
-- funcion de prueba que utilize con la base de datos de biblioteca

delimiter $$
create FUNCTION f_NombreCompletoCliente (param_idcliente INT) 
RETURNS CHAR (50)
DETERMINISTIC
BEGIN
DECLARE var char(50);
SET var =(select concat(nombre,' ',apellido)  from clientes where idcliente = param_idcliente) ;
return var;

END$$

SELECT f_NombreCompletoCliente(2) AS NombreCompleto;



-- FUNCION PARA OBTENER NOMBRE DEL JUEGO CON LA BASE DE DATOS DE GAMMERS
USE GAMMERS;
DELIMITER //

CREATE FUNCTION get_game(p_id_game INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE v_nombre VARCHAR(100);

    SELECT name INTO v_nombre
    FROM game
    WHERE id_game = p_id_game;

    RETURN v_nombre;
END //

DELIMITER ;

SELECT get_game(2) AS nombre_videojuego;




/*
Explicación:

Recibe un parámetro p_nombre de tipo CHAR(50).

Inserta ese valor en la tabla productos.

Hace un SELECT de todos los productos, ordenados de forma descendente (ORDER BY id DESC).

Esto asegura que el último registro insertado aparezca primero.

Si el parámetro está vacío (''), lanza un error con SIGNAL
*/

CREATE SCHEMA PRUEBA ;
USE PRUEBA;
-- Supongamos que tenemos esta tabla:
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre CHAR(50) NOT NULL
);

DELIMITER $$

CREATE PROCEDURE insertar_producto(IN p_nombre CHAR(50))
BEGIN
    -- Verificamos si el parámetro está vacío
    IF p_nombre = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ERROR: no se pudo crear el producto indicado por favor ingrese uno correcto';
    ELSE
        -- Insertamos el nuevo producto
        INSERT INTO productos (nombre)
        VALUES (p_nombre);

        -- Mostramos los registros ordenados descendentemente (id más alto primero)
        SELECT *
        FROM productos
        ORDER BY id desc;
    END IF;
END $$

DELIMITER ;








