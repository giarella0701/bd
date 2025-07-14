-- 1.-  Mostrar todos los usuarios de tipo Cliente
-- Seleccionar nombre de usuario, correo y tipo_usuario
SELECT u.username, u.email, t.nombre_tipo
FROM usuarios u, tipo_usuarios t
WHERE u.id_tipo_usuario = 2 AND u.id_tipo_usuario = t.id_tipo;

-- Ejemplo JOIN --
SELECT u.username, u.email, t.nombre_tipo
FROM usuarios u 
JOIN tipo_usuarios t ON u.id_tipo_usuario = t.id_tipo
WHERE u.id_tipo_usuario = 2;


-- 2.-  Mostrar Personas nacidas despues del año 1990
-- Seleccionar Nombre, fecha de nacimiento y username.
SELECT nombre_completo, fecha_nac,
    (SELECT username FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS username
FROM personas
WHERE YEAR(fecha_nac) > 1990;

-- Ejemplo JOIN --
SELECT nombre_completo, fecha_nac, username
FROM personas p
JOIN usuarios u ON u.id_usuario = p.id_usuario
WHERE YEAR(fecha_nac) > 1990;


-- 3.- Seleccionar nombres de personas que comiencen con la 
-- letra A - Seleccionar nombre y correo la persona.
SELECT nombre_completo,
    (SELECT email FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS email
FROM personas
WHERE nombre_completo LIKE 'A%';

-- Ejemplo JOIN --
SELECT nombre_completo, email
FROM personas p
JOIN usuarios u ON u.id_usuario = p.id_usuario
WHERE nombre_completo LIKE 'A%';


-- 4.- Mostrar usuarios cuyos dominios de correo sean
-- mail.commit LIKE '%mail.com%'
SELECT username, email, fecha_nac
FROM usuarios
WHERE email LIKE '%mail.com%';

-- Ejemplo JOIN --
SELECT username, email, fecha_nac
FROM usuarios u
JOIN personas p ON u.id_usuario = p.id_usuario
WHERE email LIKE '%mail.com%';


-- 5.- Mostrar todas las personas que no viven en 
 -- Valparaiso y su usuario + ciudad.
 -- select * from ciudad; -- ID 2 VALPARAISO
SELECT nombre_completo,
    (SELECT username FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS username,
    (SELECT nombre_ciudad FROM ciudad WHERE ciudad.id_ciudad = personas.id_ciudad) AS ciudad
FROM personas
WHERE id_ciudad <> 2;

-- Ejemplo JOIN --
SELECT p.nombre_completo, u.username, c.nombre_ciudad
FROM personas p
JOIN usuarios u ON p.id_usuario = u.id_usuario 
JOIN ciudad c ON p.id_ciudad = c.id_ciudad
WHERE p.id_ciudad <> 2;


-- 6.- Mostrar usuarios que contengan más de 7 
-- carácteres de longitud.
SELECT username, rut
FROM usuarios
WHERE CHAR_LENGTH(username) > 7;

-- Ejemplo JOIN --
SELECT u.username, p.rut
FROM usuarios u
JOIN personas p ON u.id_usuario = p.id_usuario
WHERE CHAR_LENGTH(username) > 7;

-- 7.- Mostrar username de personas nacidas entre
-- 1990 y 1995
SELECT 
    (SELECT username FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS username
FROM personas
WHERE YEAR(fecha_nac) BETWEEN 1990 AND 1995;

-- Ejemplo JOIN --
SELECT username
FROM usuarios u
JOIN personas p ON u.id_usuario = p.id_usuario
WHERE YEAR(fecha_nac) BETWEEN 1990 AND 1995;