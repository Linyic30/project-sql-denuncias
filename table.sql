CREATE schema denuncias_test;
USE denuncias_test;

CREATE TABLE casos (
id_caso INT NOT NULL,
id_agresor INT NOT NULL,
llamada_derivacion VARCHAR(100) NOT NULL,
victima_cantidad INT NOT NULL,
llamada_fecha DATE NOT NULL,
llamada_region VARCHAR(50) NOT NULL,
PRIMARY KEY (id_caso),
FOREIGN KEY(id_agresor) REFERENCES agresor(id_agresor)
);

CREATE TABLE llamadas (
id_caso INT NOT NULL,
id_agresor INT NOT NULL,
llamante_genero VARCHAR(50) NOT NULL,
llamante_region VARCHAR(50) NOT NULL,
llamante_descripcion VARCHAR(50) NOT NULL,
PRIMARY KEY (id_caso),
FOREIGN KEY(id_agresor) REFERENCES agresor(id_agresor)
);

CREATE TABLE agresor (
id_agresor INT NOT NULL,
id_victima INT NOT NULL,
agresor_cantidad INT NOT NULL,
agresor_genero VARCHAR(50) NOT NULL,
agresor_relacion_victima VARCHAR(50) NOT NULL,
violencia_tipo VARCHAR(50) NOT NULL,
PRIMARY KEY (id_agresor),
FOREIGN KEY(id_victima) REFERENCES victima(id_victima)
);

CREATE TABLE victima (
id_victima INT NOT NULL,
victima_edad INT NOT NULL,
victima_rango_etario VARCHAR(50) NOT NULL,
victima_genero VARCHAR(50) NOT NULL,
victima_cantidad INT NOT NULL,
PRIMARY KEY (id_victima)
);


