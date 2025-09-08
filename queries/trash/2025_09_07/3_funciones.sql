use ecobici;

-- 1) Duración en minutos del recorrido

DELIMITER $$

CREATE FUNCTION fn_dif_tiempo_minutos(fecha_origen DATETIME, fecha_dest DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
    -- Devuelve la diferencia en minutos
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

-- Ejemplo de uso de la función:

select fn_calif_barrio(3);




-- PROBAR GENERAR UNA TABLA CON LA COTIZACIÓN DEL DOLAR EN USD PARA QUE CALCULE EL PRECIO EN USD




-- Uso de la funcions








-- Calculo del precio en dolares

DELIMITER $$

CREATE FUNCTION precio_dolrecorridosares(id_prec INT, fecha DATETIME)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE valor_pesos DECIMAL(10,2);
    DECLARE dolar_mes DECIMAL(10,2);

    -- Obtener el valor en pesos del recorrido
   
   
   SELECT valor_pesos INTO valor_pesos
    FROM precios
    WHERE id_precio = id_prec;
    CASE MONTH(fecha)
        WHEN 1 THEN SET dolar_mes = 350;  -- Enero
        WHEN 2 THEN SET dolar_mes = 355;  -- Febrero
        WHEN 3 THEN SET dolar_mes = 360;  -- Marzo
        WHEN 4 THEN SET dolar_mes = 365;  -- Abril
        WHEN 5 THEN SET dolar_mes = 370;  -- Mayo
        WHEN 6 THEN SET dolar_mes = 375;  -- Junio
        WHEN 7 THEN SET dolar_mes = 380;  -- Julio
        WHEN 8 THEN SET dolar_mes = 385;  -- Agosto
        WHEN 9 THEN SET dolar_mes = 390;  -- Septiembre
        WHEN 10 THEN SET dolar_mes = 395; -- Octubre
        WHEN 11 THEN SET dolar_mes = 400; -- Noviembre
        WHEN 12 THEN SET dolar_mes = 405; -- Diciembre
    END CASE;

    -- Calcular precio en dólares
    RETURN valor_pesos / dolar_mes;
END $$

DELIMITER ;

-- Cómo usarla




-- ingresos gasto en dólares


-- Kilómetros promedio

-- distancia recorrida

select * from estaciones;

SELECT id_estacion,
       (
         6371 * ACOS(
           COS(RADIANS(latitud)) * COS(RADIANS()) *
           COS(RADIANS(lon2) - RADIANS(lon1)) +
           SIN(RADIANS(lat1)) * SIN(RADIANS(lat2))
         )
       ) AS distancia_km
FROM estaciones;

select * FROM estaciones;


select * FROM recorridos;



SELECT 
    r.id_recorrido,
    eo.id_estacion AS estacion_origen,
    ed.id_estacion AS estacion_destino,
    (6371 * ACOS(
        COS(RADIANS(eo.latitud)) 
        * COS(RADIANS(ed.latitud)) 
        * COS(RADIANS(ed.longitud) - RADIANS(eo.longitud)) 
        + SIN(RADIANS(eo.latitud)) 
        * SIN(RADIANS(ed.latitud))
    )) AS distancia_km
FROM recorridos r
JOIN estaciones eo ON r.id_estacion_orig = eo.id_estacion
JOIN estaciones ed ON r.id_estacion_dest = ed.id_estacion;


SELECT 
    g.genero_usuario AS sexo,
    (6371 * ACOS(
        COS(RADIANS(eo.latitud)) 
        * COS(RADIANS(ed.latitud)) 
        * COS(RADIANS(ed.longitud) - RADIANS(eo.longitud)) 
        + SIN(RADIANS(eo.latitud)) 
        * SIN(RADIANS(ed.latitud))
    )) AS distancia_km
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN genero g ON u.id_genero = g.id_genero
JOIN estaciones eo ON r.id_estacion_orig = eo.id_estacion
JOIN estaciones ed ON r.id_estacion_dest = ed.id_estacion;


-- Ver respuesta de cchat gpt:recorridos

SELECT 
    s.descripcion AS sexo,
    SUM(
        6371 * ACOS(
            COS(RADIANS(eo.latitud)) 
            * COS(RADIANS(ed.latitud)) 
            * COS(RADIANS(ed.longitud) - RADIANS(eo.longitud)) 
            + SIN(RADIANS(eo.latitud)) 
            * SIN(RADIANS(ed.latitud))
        )
    ) AS km_totales,
    AVG(
        6371 * ACOS(
            COS(RADIANS(eo.latitud)) 
            * COS(RADIANS(ed.latitud)) 
            * COS(RADIANS(ed.longitud) - RADIANS(eo.longitud)) 
            + SIN(RADIANS(eo.latitud)) 
            * SIN(RADIANS(ed.latitud))
        )
    ) AS km_promedio
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN sexo s ON u.id_sexo = s.id_sexo
JOIN estaciones eo ON r.id_estacion_origen = eo.id_estacion
JOIN estaciones ed ON r.id_estacion_destino = ed.id_estacion
GROUP BY s.descripcion;


-- 2) Función para calcular gasto ttoal por usuario

DELIMITER $$

CREATE FUNCTION total_consumo_usuario(p_id_usuario INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(p.precio)
    INTO total
    FROM recorridos r
    INNER JOIN precios p ON r.id_precio = p.id_precio
    WHERE r.id_usuario = p_id_usuario;

    RETURN total; -- Si no hay consumos, devuelve 0
END$$

DELIMITER ;

-- Uso de la función: 

SELECT total_consumo_usuario(4143) AS consumo_total;




-- sumar población del barrio dividido usuarios y rankear el barrio con mayor relación 
