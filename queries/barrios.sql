CREATE TABLE barrios (
    id_barrio INT PRIMARY KEY,
    barrio VARCHAR(50),
    id_comuna INT,
    comuna VARCHAR(20),
    poblacion INT,
    mujeres INT,
    varones INT
);

--faltan los otros 38 barrios


INSERT INTO barrios (id_barrio, barrio, id_comuna, comuna, poblacion, mujeres, varones) VALUES
(1, 'Agronomia', 15, 'Comuna 15', 13963, 7493, 6470),
(2, 'Almagro', 5, 'Comuna 5', 128206, 71821, 56385),
(3, 'Balvanera', 3, 'Comuna 3', 137521, 76332, 61189),
(4, 'Barracas', 4, 'Comuna 4', 73377, 39030, 34347),
(5, 'Belgrano', 13, 'Comuna 13', 126816, 70731, 56085),
(6, 'Boedo', 5, 'Comuna 5', 45563, 24556, 21007),
(7, 'Caballito', 6, 'Comuna 6', 170309, 95110, 75199),
(8, 'Chacarita', 15, 'Comuna 15', 25778, 13763, 12015),
(9, 'Coghlan', 12, 'Comuna 12', 18021, 9788, 8233),
(10, 'Colegiales', 13, 'Comuna 13', 52391, 29412, 22979);



