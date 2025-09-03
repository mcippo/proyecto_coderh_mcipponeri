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