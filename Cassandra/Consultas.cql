# Crear un keyspace

CREATE KEYSPACE nombre_del_keyspace
WITH replication = {'class':'SimpleStrategy', 'replication_factor' : N};

# Crear una tabla

CREATE TABLE nombre_de_la_tabla (
    columna1 tipo_de_dato1,
    columna2 tipo_de_dato2,
    ...
    PRIMARY KEY (columna1)
);

# Insertar datos en una tabla

INSERT INTO nombre_de_la_tabla (columna1, columna2, ...)
VALUES (valor1, valor2, ...);

# Leer datos en una tabla

SELECT * FROM nombre_de_la_tabla;

# Actualizar datos en una tabla

UPDATE nombre_de_la_tabla
SET columna1 = valor1, columna2 = valor2, ...
WHERE columna1 = valor;

# Eliminar datos de una tabla

DELETE FROM nombre_de_la_tabla
WHERE columna1 = valor;
