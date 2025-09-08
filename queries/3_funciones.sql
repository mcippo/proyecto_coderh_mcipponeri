use ecobici;

-- 1) Duración en minutos del recorrido

DELIMITER $$

CREATE FUNCTION fn_dif_tiempo_minutos(fecha_origen DATETIME, fecha_dest DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(MINUTE, fecha_origen, fecha_dest);
END $$

DELIMITER ;

-- Primer ejemplo de utilización de la función:

SELECT 
    id_recorrido,
    fecha_origen,
    fecha_dest,
    fn_dif_tiempo_minutos(fecha_origen, fecha_dest) AS minutos
FROM recorridos;

-- Segundo ejemplo de uso de la función (considerando la variable sexo):

SELECT 
    g.genero_usuario AS sexo,
    AVG(fn_dif_tiempo_minutos(r.fecha_origen, r.fecha_dest)) AS promedio_minutos
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY g.genero_usuario;

-- 2) Calificación promedio otorgada a los recorridos según Barrio de origen:

DELIMITER $$

CREATE FUNCTION fn_calif_barrio(f_id_barrio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE promedio DECIMAL(10,2);
  SELECT IFNULL(AVG(r.calificacion), 0)
  INTO promedio
  FROM recorridos r
  INNER JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
  INNER JOIN barrio b ON e.id_barrio = b.id_barrio
  WHERE b.id_barrio = f_id_barrio;
  RETURN promedio;
END $$

DELIMITER ;

-- Ejemplo de uso de la función (para el barrio de Balvanera -id 3-):

select fn_calif_barrio(3);


