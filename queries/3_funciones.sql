use ecobici;


-- sumar población del barrio dividido usuarios y rankear el barrio con mayor relación 

-- duracion promedio, esto debería funcionar bien de una

DELIMITER $$

CREATE FUNCTION dif_tiempo_minutos(fecha_origen DATETIME, fecha_dest DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
    -- Devuelve la diferencia en minutos
    RETURN TIMESTAMPDIFF(MINUTE, fecha_origen, fecha_dest);
END $$

DELIMITER ;

-- Utilización:

SELECT 
    id_recorrido,
    fecha_origen,
    fecha_dest,
    dif_tiempo_minutos(fecha_origen, fecha_dest) AS minutos
FROM recorridos;

-- Cálculo de los minutos recorridos por sexo con la función

SELECT 
    g.genero_usuario AS sexo,
    AVG(dif_tiempo_minutos(r.fecha_origen, r.fecha_dest)) AS promedio_minutos
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY g.genero_usuario;

-- Calculo del precio en dolares

DELIMITER $$

CREATE FUNCTION precio_dolares(id_prec INT, fecha DATETIME)
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

