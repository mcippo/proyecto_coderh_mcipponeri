
use ecobici;

-- Store procedure para dentros los barrios, la comuna a la que pertenecen, la estación, la dirección de la misma


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

CALL estaciones_por_barrio(48);

select * FROM barrio;


-- Otro SP puede ser las características de los recorridos de cada usuario



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