USE ecobici;

-- 1) Distribución de los recorridos según edad

CREATE VIEW vista_recorridos_x_edad AS
SELECT u.edad_usuario, COUNT(r.id_usuario) AS total_recorridos
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
GROUP BY u.edad_usuario
ORDER BY u.edad_usuario;

-- Ejemplo de uso

SELECT * FROM vista_recorridos_x_edad;


-- 2) Distribución porcentual de los recorridos según grupo etario:

CREATE VIEW vista_recorridos_porc_getario AS
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

-- Ejemplo de uso

SELECT * FROM vista_recorridos_porc_getario;

-- 3) Distribución porcentual por genero:

CREATE VIEW vista_recorridos_porc_genero AS
SELECT 
    g.genero_usuario AS sexo,
    COUNT(r.id_recorrido) AS total_recorridos,
    ROUND( COUNT(r.id_recorrido) * 100.0 / SUM(COUNT(r.id_recorrido)) OVER (), 1 ) AS porcentaje
FROM recorridos r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY g.genero_usuario;

-- Ejemplo de uso

SELECT * FROM vista_recorridos_porc_genero;

-- 4) Distribución porcentual de los recorridos por edad y sexo:

CREATE VIEW vista_recorridos_porc_genero_edad AS
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

-- Ejemplo de uso

SELECT * FROM vista_recorridos_porc_genero_edad;

-- 5) Calificación del recorrido según tipo de bici utilizada

CREATE VIEW vista_calificaciones_modelo AS
SELECT m.modelo, AVG(r.calificacion) AS calificacion_promedio
FROM recorridos r
JOIN modelo m ON r.id_modelo = m.id_modelo
GROUP BY m.id_modelo
ORDER BY m.id_modelo;

-- Ejemplo de uso:

SELECT * FROM vista_calificaciones_modelo;

-- 6) Calificación de los recorridos según barrio

CREATE VIEW vista_calificacion_barrio AS
SELECT b.nombre_barrio AS barrio, AVG(r.calificacion) AS calificacion_promedio
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
JOIN barrio b ON e.id_barrio = b.id_barrio
GROUP BY b.nombre_barrio
ORDER BY calificacion_promedio DESC;

-- Ejemplo de uso:

select * FROM vista_calificacion_barrio;

-- 7) Calificación por estación:

CREATE VIEW vista_calif_estacion AS 
SELECT e.nombre AS nombre_estacion, AVG(r.calificacion) AS calificacion_promedio
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
GROUP BY e.id_estacion
ORDER BY calificacion_promedio DESC;

-- Ejemplo de uso

select * FROM vista_calif_estacion;


-- 8) Cantidad de recorridos por estación

CREATE VIEW vista_recorridos_x_est AS
SELECT e.nombre AS nombre_estacion, count(r.id_recorrido) AS cantidad_recorridos
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
GROUP BY nombre_estacion
ORDER BY cantidad_recorridos DESC;

-- Ejemplo de uso:

SELECT * FROM vista_recorridos_x_est;

-- 9) Estación con más recorridos

CREATE VIEW vista_top_estacion AS
SELECT e.nombre AS nombre_estacion, count(r.id_recorrido) AS cantidad_recorridos
FROM recorridos r
JOIN estaciones e ON r.id_estacion_orig = e.id_estacion
GROUP BY nombre_estacion
ORDER BY cantidad_recorridos DESC
LIMIT 1;

-- Ejemplos de uso:

SELECT * FROM vista_top_estacion;

-- 10) Cantidad de usuarios por sexo

CREATE VIEW vista_usuarios_genero AS
SELECT g.genero_usuario AS genero, count(u.id_usuario) AS cantidad_usuarios
FROM usuarios u 
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY genero
ORDER BY cantidad_usuarios;

-- Ejemplo de uso

SELECT * FROM vista_usuarios_genero;

-- 11) Usuarios por grupo de edad

CREATE VIEW vista_usuarios_edad AS
SELECT g.genero_usuario AS genero, count(u.id_usuario) AS cantidad_usuarios
FROM usuarios u 
JOIN genero g ON u.id_genero = g.id_genero
GROUP BY genero
ORDER BY cantidad_usuarios DESC;

-- Ejemplo de uso:

SELECT * FROM vista_usuarios_edad;

-- 12) Ingresos que se podrían haber generado por pagar el servicio

CREATE VIEW vista_ganancias AS
SELECT SUM(p.precio) AS gasto_total
FROM recorridos r
JOIN precios p ON r.id_precio = p.id_precio;

-- Ejemplo:

SELECT * FROM vista_ganancias;

-- 13) Ingresos generados por estación

CREATE VIEW vista_ingresos_est AS
SELECT e.nombre AS nombre_estacion, SUM(p.precio) AS gasto_total
FROM recorridos r
JOIN estaciones e  ON r.id_estacion_orig = e.id_estacion
JOIN precios p ON r.id_precio = p.id_precio
GROUP BY nombre_estacion;

-- Ejemplo de uso:

SELECT * FROM vista_ingresos_est;

-- VER DESPUES:

-- Kilómetros recorridos por estación

-- Kilometros recorridos por Sexo

-- Kilómetros recorridos por edad

-- Duración promedio del recorrido

-- Duración promedio por sexo

-- Duración promedio por edad
