

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

