
use ecobici;

-- 1) Objetivo: identificar a las estaciones que se encuentran en cada barrio

DELIMITER $$

CREATE PROCEDURE estaciones_por_barrio (IN p_id_barrio INT)
BEGIN
    SELECT 
		b.nombre_barrio AS barrio,
        c.nombre_comuna AS comuna,
        e.nombre AS estacion,
        e.direccion
    FROM estaciones e
    INNER JOIN barrio b ON e.id_barrio = b.id_barrio
    INNER JOIN comuna c ON b.id_comuna = c.id_comuna
    WHERE b.id_barrio = p_id_barrio
    ORDER BY e.nombre;
END$$

DELIMITER ;

-- Ejemplo para el barrio Belgrano (id 5), los id de los barrios barrios van del 1 al 48

CALL estaciones_por_barrio(5);

-- 2) Identificación de recorridos por usuarios

DELIMITER $$

CREATE PROCEDURE recorridos_usuario (IN p_id_usuario INT)
BEGIN
    SELECT 
		u.id_usuario AS usuario,
        g.genero_usuario AS genero,
        u.edad_usuario AS edad,
        r.fecha_origen AS fecha,
        e.nombre AS estacion,
        b.nombre_barrio AS barrio,
        c.nombre_comuna AS comuna,
        e.direccion,
        r.calificacion
    FROM recorridos r
    INNER JOIN usuarios u ON r.id_usuario = u.id_usuario
    INNER JOIN genero g ON u.id_genero = g.id_genero
    INNER JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
    INNER JOIN barrio b ON e.id_barrio = b.id_barrio
    INNER JOIN comuna c ON b.id_comuna = c.id_comuna
    WHERE u.id_usuario = p_id_usuario
    ORDER BY r.fecha_origen;
END$$

DELIMITER ;

-- Ejemplo de uso del SP con el id de usuario 4143:

CALL recorridos_usuario(4143);





-- ver este ejemplo después

-- ranking de estaciones más utilizadas

DELIMITER $$

CREATE PROCEDURE ranking_barrios (
    IN p_limite INT
)
BEGIN
    SELECT b.nombre_barrio,
           COUNT(*) AS total_recorridos
    FROM recorridos r
    JOIN estaciones e ON r.id_estacion_origen = e.id_estacion
    JOIN barrios b ON e.id_barrio = b.id_barrio
    GROUP BY b.id_barrio
    ORDER BY total_recorridos DESC
    LIMIT p_limite;
END;

DELIMITER ;