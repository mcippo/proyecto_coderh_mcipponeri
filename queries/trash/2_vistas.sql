

USE ecobici;

-- Distribución de los recorridos según edad: (después vemos cómo generar la agrupación)

SELECT u.edad_usuario, COUNT(r.id_usuario) AS total_recorridos
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
GROUP BY u.edad_usuario
ORDER BY u.edad_usuario;

-- Se agrupa por rango de edad

SELECT 
    CASE 
        WHEN u.edad_usuario BETWEEN 0 AND 17 THEN 'menores de 17'
        WHEN u.edad_usuario BETWEEN 18 AND 25 THEN 'entre 18 y 25'
        WHEN u.edad_usuario BETWEEN 26 AND 35 THEN 'entre 26 y 35'
        WHEN u.edad_usuario BETWEEN 36 AND 50 THEN 'entre 36 y 50'
        WHEN u.edad_usuario BETWEEN 51 AND 64 THEN 'entre 51 y 64'
        ELSE '65 o mas' 
    END AS grupo_etario,
    COUNT(r.id_recorrido) AS total_recorridos,
    ROUND( COUNT(r.id_recorrido) * 100.0 / SUM(COUNT(r.id_recorrido)) OVER (), 1 ) AS porcentaje
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
GROUP BY grupo_etario
ORDER BY FIELD(grupo_etario, 'menores de 17',
'entre 18 y 25',
'entre 26 y 35',
'entre 36 y 50',
'entre 51 y 64',
'65 o mas');

-- Por sexo:

SELECT 
    g.genero_usuario AS sexo,
    COUNT(r.id_recorrido) AS total_recorridos,
    ROUND( COUNT(r.id_recorrido) * 100.0 / SUM(COUNT(r.id_recorrido)) OVER (), 1 ) AS porcentaje
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY g.genero_usuario;

-- Por sexo y edad:

SELECT CASE 
        WHEN u.edad_usuario BETWEEN 0 AND 17 THEN 'menores de 17'
        WHEN u.edad_usuario BETWEEN 18 AND 25 THEN 'entre 18 y 25'
        WHEN u.edad_usuario BETWEEN 26 AND 35 THEN 'entre 26 y 35'
        WHEN u.edad_usuario BETWEEN 36 AND 50 THEN 'entre 36 y 50'
        WHEN u.edad_usuario BETWEEN 51 AND 64 THEN 'entre 51 y 64'
        ELSE 'Mayores de 65' 
    END AS grupo_etario, 
    g.genero_usuario AS sexo,
    COUNT(r.id_recorrido) AS total_recorridos,
    ROUND( COUNT(r.id_recorrido) * 100.0 / SUM(COUNT(r.id_recorrido)) OVER (), 1 ) AS porcentaje
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY g.genero_usuario, grupo_etario
ORDER BY FIELD(grupo_etario, 'menores de 17',
'entre 18 y 25',
'entre 26 y 35',
'entre 36 y 50',
'entre 51 y 64',
'Mayores de 65');

-- Calificación del recorrido según tipo de bici utilizada

CREATE VIEW vista_calificaciones_modelo AS
SELECT m.modelo, AVG(r.calificacion) AS calificacion_promedio
FROM recorridos r
JOIN modelo m ON r.id_modelo = m.id_modelo
GROUP BY m.id_modelo
ORDER BY m.id_modelo;

SELECT * FROM vista_calificaciones_modelo;

-- Calificación del recorrido según barrio

SELECT m.modelo, AVG(r.calificacion) AS calificacion_promedio
FROM recorridos r
JOIN modelo m ON r.id_modelo = m.id_modelo
GROUP BY m.id_modelo
ORDER BY m.id_modelo;


-- Cantidad de recorridos por barrio

SELECT b.nombre_barrio AS barrio, AVG(r.calificacion) AS calificacion_promedio
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
JOIN barrio b ON e.id_barrio = b.id_barrio
GROUP BY b.nombre_barrio
ORDER BY calificacion_promedio DESC;

-- Calificación por estación:

SELECT e.nombre AS nombre_estacion, AVG(r.calificacion) AS calificacion_promedio
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
GROUP BY e.id_estacion
ORDER BY calificacion_promedio DESC;

-- Cantidad de recorridos por estación

SELECT e.nombre AS nombre_estacion, count(r.id_recorrido) AS cantidad_recorridos
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
GROUP BY nombre_estacion
ORDER BY cantidad_recorridos DESC;

-- Estación con más recorridos

SELECT e.nombre AS nombre_estacion, count(r.id_recorrido) AS cantidad_recorridos
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
GROUP BY nombre_estacion
ORDER BY cantidad_recorridos DESC
LIMIT 1;

-- Cantidad de usuarios por sexo

SELECT g.genero_usuario AS genero, count(u.id_usuario) AS cantidad_usuarios
FROM usuarios u 
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY genero
ORDER BY cantidad_usuarios;

-- Cantidad de usuarios por grupo de edad

SELECT g.genero_usuario AS genero, count(u.id_usuario) AS cantidad_usuarios
FROM usuarios u 
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY genero
ORDER BY cantidad_usuarios;

-- Ingresos que se podrían haber generado por pagar el servicio

SELECT SUM(p.precio) AS gasto_total
FROM recorridos r
JOIN precios p ON r.id_precio = p.id_precio;

-- Ingresos generados por estación

SELECT e.nombre AS nombre_estacion, SUM(p.precio) AS gasto_total
FROM recorridos r
JOIN estaciones e  ON r.id_estacion_orig = e.id_estacion
JOIN precios p ON r.id_precio = p.id_precio
GROUP BY nombre_estacion;

-- Kilómetros recorridos por estación

-- Kilometros recorridos por Sexo

-- Kilómetros recorridos por edad

-- Duración promedio del recorrido

-- Duración promedio por sexo

-- Duración promedio por edad
