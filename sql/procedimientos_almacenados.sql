
USE `sistema_seguridad_vial`;

/* =======================================================
   2) Procedimientos Almacenados (SP)
   ======================================================= */

-- Cambiar el delimitador para permitir la creación de procedimientos.
DELIMITER //

/*-----------------------------------------------------------
-- 2.1) SPs para la tabla ROL (Catálogo)
-----------------------------------------------------------*/

-- 2.1.1. Insertar Rol
CREATE PROCEDURE sp_rol_insertar(
    IN p_nombre_rol VARCHAR(45)
)
BEGIN
    INSERT INTO Rol (nombre_rol, deleted)
    VALUES (p_nombre_rol, 0);
END//
DELIMITER ;

-- 2.1.2. Listar Roles Activos
DELIMITER //
CREATE PROCEDURE sp_rol_listar_activos()
BEGIN
    SELECT 
        idRol, 
        nombre_rol, 
        created_at
    FROM Rol
    WHERE deleted = 0
    ORDER BY nombre_rol;
END//
DELIMITER ;

-- 2.1.3. Borrado Lógico de Rol
DELIMITER //
CREATE PROCEDURE sp_rol_borrado_logico(
    IN p_idRol INT
)
BEGIN
    UPDATE Rol
    SET deleted = 1, updated_at = CURRENT_TIMESTAMP
    WHERE idRol = p_idRol;
END//
DELIMITER ;

/*-----------------------------------------------------------
-- 2.2) SPs para la tabla USUARIOS (Entidad Central)
-----------------------------------------------------------*/

-- 2.2.1. Insertar Usuario
-- NOTA: Se asume que la contraseña ya viene hasheada.
DELIMITER //
CREATE PROCEDURE sp_usuarios_insertar(
    IN p_correo VARCHAR(100),
    IN p_contraseña VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_nombre VARCHAR(45),
    IN p_apellido VARCHAR(45),
    IN p_ciudad VARCHAR(45),
    IN p_comuna VARCHAR(45),
    IN p_rut VARCHAR(12),
    IN p_Rol_idRol INT
)
BEGIN
    INSERT INTO Usuarios (correo, contraseña, telefono, nombre, apellido, ciudad, comuna, rut, Rol_idRol, deleted)
    VALUES (p_correo, p_contraseña, p_telefono, p_nombre, p_apellido, p_ciudad, p_comuna, p_rut, p_Rol_idRol, 0);
END//
DELIMITER ;
-- 2.2.2. Listar Usuarios Activos con su Rol
DELIMITER //
CREATE PROCEDURE sp_usuarios_listar_activos()
BEGIN
    SELECT 
        u.idUsuarios, 
        u.correo, 
        u.telefono, 
        u.nombre, 
        u.apellido, 
        u.rut,
        r.nombre_rol AS rol_asignado,
        u.Fecha_registro
    FROM Usuarios u
    INNER JOIN Rol r ON u.Rol_idRol = r.idRol
    WHERE u.deleted = 0
    ORDER BY u.apellido, u.nombre;
END//
DELIMITER ;

-- 2.2.3. Borrado Lógico de Usuario
DELIMITER //
CREATE PROCEDURE sp_usuarios_borrado_logico(
    IN p_idUsuarios INT
)
BEGIN
    UPDATE Usuarios
    SET deleted = 1, updated_at = CURRENT_TIMESTAMP
    WHERE idUsuarios = p_idUsuarios;
END//
DELIMITER ;

/*-----------------------------------------------------------
-- 2.3) SPs para la tabla ACCIDENTE
-----------------------------------------------------------*/

-- 2.3.1. Insertar Accidente
DELIMITER //
CREATE PROCEDURE sp_accidente_insertar(
    IN p_descripcion TEXT,
    IN p_severidad VARCHAR(45),
    IN p_ubicacion VARCHAR(255),
    IN p_tipo_accidente VARCHAR(45),
    IN p_fecha_accidente DATETIME,
    IN p_Usuarios_idUsuarios INT -- Usuario que reporta
)
BEGIN
    -- El estado por defecto es 'Reportado' según la definición de la tabla
    INSERT INTO Accidente (descripcion, severidad, ubicacion, tipo_accidente, fecha_accidente, Usuarios_idUsuarios, deleted)
    VALUES (p_descripcion, p_severidad, p_ubicacion, p_tipo_accidente, p_fecha_accidente, p_Usuarios_idUsuarios, 0);
END//
DELIMITER ;

-- 2.3.2. Listar Accidentes Activos (con reportero)
DELIMITER //
CREATE PROCEDURE sp_accidente_listar_activos()
BEGIN
    SELECT 
        a.idAccidente, 
        a.severidad, 
        a.ubicacion, 
        a.tipo_accidente, 
        a.fecha_accidente,
        a.estado,
        CONCAT(u.nombre, ' ', u.apellido) AS reportado_por
    FROM Accidente a
    INNER JOIN Usuarios u ON a.Usuarios_idUsuarios = u.idUsuarios
    WHERE a.deleted = 0
    ORDER BY a.fecha_accidente DESC;
END//
DELIMITER ;

-- 2.3.3. Actualizar Estado de Accidente
DELIMITER //
CREATE PROCEDURE sp_accidente_actualizar_estado(
    IN p_idAccidente INT,
    IN p_nuevo_estado VARCHAR(45) -- (e.g., 'En Revisión', 'Cerrado')
)
BEGIN
    UPDATE Accidente
    SET estado = p_nuevo_estado, updated_at = CURRENT_TIMESTAMP
    WHERE idAccidente = p_idAccidente;
END//
DELIMITER ;

-- 2.3.4. Borrado Lógico de Accidente
DELIMITER //
CREATE PROCEDURE sp_accidente_borrado_logico(
    IN p_idAccidente INT
)
BEGIN
    UPDATE Accidente
    SET deleted = 1, updated_at = CURRENT_TIMESTAMP
    WHERE idAccidente = p_idAccidente;
END//
DELIMITER ;

/*-----------------------------------------------------------
-- 2.4) SPs para la tabla REPORTE
-----------------------------------------------------------*/

-- 2.4.1. Insertar Reporte
DELIMITER //
CREATE PROCEDURE sp_reporte_insertar(
    IN p_tipo_reporte VARCHAR(45), -- 'Queja', 'Sugerencia', 'Error', 'Otro'
    IN p_detalle TEXT
)
BEGIN
    INSERT INTO Reporte (tipo_reporte, detalle, fecha_reporte, deleted)
    VALUES (p_tipo_reporte, p_detalle, CURRENT_DATE(), 0);
END//
DELIMITER ;

-- 2.4.2. Listar Reportes Activos
DELIMITER //
CREATE PROCEDURE sp_reporte_listar_activos()
BEGIN
    SELECT 
        idReporte, 
        tipo_reporte, 
        detalle, 
        fecha_reporte
    FROM Reporte
    WHERE deleted = 0
    ORDER BY fecha_reporte DESC;
END//
DELIMITER ;

-- 2.4.3. Borrado Lógico de Reporte
DELIMITER //
CREATE PROCEDURE sp_reporte_borrado_logico(
    IN p_idReporte INT
)
BEGIN
    UPDATE Reporte
    SET deleted = 1, updated_at = CURRENT_TIMESTAMP
    WHERE idReporte = p_idReporte;
END//
DELIMITER ;
/*-----------------------------------------------------------
-- 2.5) SPs para la tabla LEYES_NORMAS
-----------------------------------------------------------*/

-- 2.5.1. Insertar Ley o Norma
DELIMITER //
CREATE PROCEDURE sp_leyes_normas_insertar(
    IN p_titulo VARCHAR(255),
    IN p_categoria VARCHAR(45),
    IN p_fecha_publicacion DATE
)
BEGIN
    INSERT INTO Leyes_Normas (titulo, categoria, fecha_publicacion, deleted)
    VALUES (p_titulo, p_categoria, p_fecha_publicacion, 0);
END//
DELIMITER ;

-- 2.5.2. Listar Leyes/Normas Activas
DELIMITER //
CREATE PROCEDURE sp_leyes_normas_listar_activos()
BEGIN
    SELECT 
        id_Ley, 
        titulo, 
        categoria, 
        fecha_publicacion
    FROM Leyes_Normas
    WHERE deleted = 0
    ORDER BY fecha_publicacion DESC, titulo;
END//
DELIMITER ;

-- 2.5.3. Borrado Lógico de Ley o Norma
DELIMITER //
CREATE PROCEDURE sp_leyes_normas_borrado_logico(
    IN p_id_Ley INT
)
BEGIN
    UPDATE Leyes_Normas
    SET deleted = 1, updated_at = CURRENT_TIMESTAMP
    WHERE id_Ley = p_id_Ley;
END//

-- Restaurar el delimitador por defecto
DELIMITER ;