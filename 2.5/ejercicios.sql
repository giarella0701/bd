-- 1.-  Mostrar todos los usuarios de tipo Cliente
-- Seleccionar nombre de usuario, correo y tipo_usuario
SELECT u.username, u.email, t.nombre_tipo
FROM usuarios u, tipo_usuarios t
WHERE u.id_tipo_usuario = 2
AND u.id_tipo_usuario = t.id_tipo;


-- 2.-  Mostrar Personas nacidas despues del año 1990
-- Seleccionar Nombre, fecha de nacimiento y username.
SELECT nombre_completo, fecha_nac,
    (SELECT username FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS username
FROM personas
WHERE YEAR(fecha_nac) > 1990;



-- 3.- Seleccionar nombres de personas que comiencen con la 
-- letra A - Seleccionar nombre y correo la persona.
SELECT nombre_completo,
    (SELECT email FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS email
FROM personas
WHERE nombre_completo LIKE 'A%';


-- 4.- Mostrar usuarios cuyos dominios de correo sean
-- mail.commit LIKE '%mail.com%'
SELECT username, email
FROM usuarios
WHERE email LIKE '%mail.com%';


-- 5.- Mostrar todas las personas que no viven en 
 -- Valparaiso y su usuario + ciudad.
 -- select * from ciudad; -- ID 2 VALPARAISO
SELECT nombre_completo,
    (SELECT username FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS username,
    (SELECT nombre_ciudad FROM ciudad WHERE ciudad.id_ciudad = personas.id_ciudad) AS ciudad
FROM personas
WHERE id_ciudad <> 2;


-- 6.- Mostrar usuarios que contengan más de 7 
-- carácteres de longitud.
SELECT username
FROM usuarios
WHERE CHAR_LENGTH(username) > 7;


-- 7.- Mostrar username de personas nacidas entre
-- 1990 y 1995
SELECT 
    (SELECT username FROM usuarios WHERE usuarios.id_usuario = personas.id_usuario) AS username
FROM personas
WHERE YEAR(fecha_nac) BETWEEN 1990 AND 1995;