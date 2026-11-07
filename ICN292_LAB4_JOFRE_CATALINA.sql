DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

-- 1. Tabla autores
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL
);

-- 2. Tabla libros (id_coleccion apunta a colecciones)
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    id_coleccion INT NOT NULL,
    titulo VARCHAR(120) NOT NULL,
    paginas INT,
    ejemplares_vendidos INT,
    anio INT,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- 3. Tabla colecciones (requerida por la consulta 9)
CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL
);

-- Añadimos la llave foránea que faltaba en libros para colecciones
ALTER TABLE libros 
ADD CONSTRAINT fk_libros_coleccion 
FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion);

-- 4. Tabla pagos (requerida por la consulta 10)
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- ==========================================
-- CARGA OFICIAL DE AUTORES (6 autores)
-- ==========================================
INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

-- ==========================================
-- CARGA DE COLECCIONES Y PAGOS (Prueba)
-- ==========================================
INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
('Biblioteca Austral Clasica', '2023-03-15'),
('Coleccion Contemporanea', '2024-01-10');

INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
(1, '2024-05-10', 150000.50),
(2, '2024-06-12', 200000.00),
(2, '2024-08-20', 95000.25);

-- ==========================================
-- CARGA OFICIAL DE LIBROS (12 libros)
-- Asignamos id_coleccion 1 o 2 a cada uno
-- ==========================================
INSERT INTO libros (id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio) VALUES
(1, 1, 'Cielo de Enero', 210, 1500, 2024),
(1, 1, 'Marea Baja', 185, 800, 2023),
(1, 1, 'El Norte', 200, 2200, 2024),
(2, 1, 'Estrellas que Caen', 240, 3000, 2022),
(2, 2, 'Maquinas', 215, 450, 2024),
(3, 2, 'Luz Artificial', 300, 1200, 2024),
(3, 2, 'Ruido Blanco', 280, 600, 2023),
(4, 2, 'El Barrio de Lila', 190, 5000, 2024),
(4, 2, 'Antes del Amanecer', 205, 2700, 2024),
(4, 2, 'La Calle 8', 175, 900, 2023),
(5, 1, 'Flor de Hierro', 195, 4100, 2024),
(5, 1, 'Hora Dorada', 220, 1800, 2022);
USE austral;


-- CONSULTA 1

SELECT nombre, genero 
FROM autores 
WHERE pais <> 'Chile' OR pais IS NULL 
ORDER BY nombre;




-- CONSULTA 2

SELECT titulo, paginas 
FROM libros 
WHERE paginas BETWEEN 190 AND 220 
ORDER BY paginas ASC;



-- CONSULTA 3

SELECT 
    COUNT(*) AS total_libros,
    SUM(ejemplares_vendidos) AS suma_ejemplares,
    AVG(paginas) AS promedio_paginas,
    MIN(anio) AS anio_antiguo,
    MAX(ejemplares_vendidos) AS max_ejemplares
FROM libros;



-- CONSULTA 4

SELECT DISTINCT genero 
FROM autores 
ORDER BY genero ASC;



-- CONSULTA 5

SELECT a.nombre, COUNT(l.id_libro) AS libros_2024
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(l.id_libro) > 1
ORDER BY a.nombre;



-- CONSULTA 6

SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE anio = 2024 AND ejemplares_vendidos > 2000 
ORDER BY ejemplares_vendidos DESC 
LIMIT 3;



-- CONSULTA 7 

-- ver la fila que se va a borrar
SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- ingresar libro solicitado
INSERT INTO libros (id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio) 
VALUES (3, 2, 'Papel Mojado', 260, 50, 2024);


-- quitar que filtra por título
DELETE FROM libros WHERE titulo = 'Papel Mojado';

-- comprobar que ya no está
SELECT * FROM libros WHERE titulo = 'Papel Mojado';




-- CONSULTA 8 

-- select previo
SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE titulo = 'Cielo de Enero';

-- update + 100 
UPDATE libros 
SET ejemplares_vendidos = ejemplares_vendidos + 100 
WHERE titulo = 'Cielo de Enero';

-- select final 
SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE titulo = 'Cielo de Enero';



-- CONSULTA 9 

SELECT l.titulo AS titulo_libro, c.titulo AS titulo_coleccion, c.fecha_publicacion 
FROM libros l
JOIN colecciones c ON l.id_coleccion = c.id_coleccion;



-- CONSULTA 10 

-- Parte A
SELECT a.nombre, p.fecha_pago, p.monto 
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor;

-- Parte B
SELECT a.nombre, SUM(p.monto) AS total_pagado 
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor
GROUP BY a.id_autor, a.nombre;
