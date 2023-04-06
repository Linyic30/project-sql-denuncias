CREATE schema denuncias_test;
USE denuncias_test;

CREATE TABLE victima (
id_victima VARCHAR(50) NOT NULL,
victima_edad INT NOT NULL,
victima_rango_etario VARCHAR(50) NOT NULL,
victima_genero VARCHAR(50) NOT NULL,
victima_cantidad INT NOT NULL,
PRIMARY KEY (id_victima)
);

CREATE TABLE agresor (
id_agresor VARCHAR(50) NOT NULL,
id_victima VARCHAR(50) NOT NULL,
agresor_cantidad INT NOT NULL,
agresor_genero VARCHAR(50) NOT NULL,
agresor_relacion_victima VARCHAR(50) NOT NULL,
violencia_tipo VARCHAR(50) NOT NULL,
PRIMARY KEY (id_agresor),
FOREIGN KEY(id_victima) REFERENCES victima(id_victima)
);

CREATE TABLE casos (
id_casos INT NOT NULL,
id_agresor VARCHAR(50) NOT NULL,
llamada_derivacion VARCHAR(100) NOT NULL,
victima_cantidad INT NOT NULL,
llamada_fecha DATE NOT NULL,
llamada_region VARCHAR(50) NOT NULL,
PRIMARY KEY (id_casos),
FOREIGN KEY(id_agresor) REFERENCES agresor(id_agresor)
);

CREATE TABLE llamada (
id_casos INT NOT NULL,
id_agresor VARCHAR(50) NOT NULL,
llamante_genero VARCHAR(50) NOT NULL,
llamada_region VARCHAR(50) NOT NULL,
llamante_descripcion VARCHAR(50) NOT NULL,
PRIMARY KEY (id_casos),
FOREIGN KEY (id_agresor) REFERENCES agresor(id_agresor)
);

CREATE VIEW victimas_2022 AS
(SELECT count(victima_cantidad) as victimas, llamada_fecha as fecha
FROM casos
GROUP BY llamada_fecha);

CREATE VIEW danio_victima AS
(SELECT violencia_tipo , victima_rango_etario, victima_cantidad
FROM victima a
LEFT JOIN agresor b
ON a.id_victima = b.id_victima);

CREATE VIEW datos_llamada AS
(SELECT c.id_casos, c.llamada_region, llamada_derivacion as descripcion, llamada_fecha as fecha
FROM casos c
LEFT JOIN llamada d
ON c.id_casos = d.id_casos);

CREATE VIEW datos_agresor AS
(SELECT  count(agresor_cantidad) as cantidad, violencia_tipo, agresor_genero
FROM agresor
GROUP BY agresor_cantidad, violencia_tipo,agresor_genero);

CREATE VIEW cantidad_denuncias_region AS
(SELECT llamada_region as region, count(id_casos) as cantidad
FROM llamada
GROUP BY llamada_region);

DELIMITER $$
CREATE FUNCTION casos_por_region(reg VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE casos_count INT;
    SELECT COUNT(*)
    INTO casos_count
    FROM casos
    WHERE llamada_region = reg;
    RETURN casos_count;
END;

CREATE FUNCTION info_casos_victima(nombre_victima VARCHAR(100))
RETURNS TABLE
DETERMINISTIC
BEGIN

 CREATE TEMPORARY TABLE resultado (
    numero_casos INT,
    victima_edad INT,
    agresor_genero VARCHAR(50),
    violencia_tipo VARCHAR(50),
    agresor_relacion_victima VARCHAR(50)
  );
  
  INSERT INTO resultado (numero_casos, victima_edad, agresor_genero, violencia_tipo, agresor_relacion_victima)
  SELECT COUNT(*) AS numero_casos, v.victima_edad, a.agresor_genero, a.violencia_tipo, a.agresor_relacion_victima
  FROM casos c
  JOIN agresor a ON c.id_agresor = a.id_agresor
  JOIN victima v ON a.id_victima = v.id_victima
  WHERE v.id_victima = nombre_victima
  GROUP BY v.victima_edad, a.agresor_genero, a.violencia_tipo, a.agresor_relacion_victima;
  
  RETURN TABLE resultado;
END;