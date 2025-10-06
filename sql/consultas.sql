-- SCRIPT 2: INSERCIONES DE DATOS Y CONSULTAS DE PRUEBA
-- Archivo: inserciones_pruebas.sql

USE `sistema_seguridad_vial`;

-- 1. INSERCIÓN DE DATOS

-- Inserción en la tabla Rol
INSERT INTO `Rol` (`idRol`, `nombre_rol`) VALUES
(1, 'Administrador'),
(2, 'Inspector'),
(3, 'Usuario General');

-- Inserción en la tabla Reporte
INSERT INTO `Reporte` (`idReporte`, `tipo_reporte`, `detalle`, `fecha_reporte`) VALUES
(101, 'Queja', 'Semáforo dañado en Avenida Central.', '2025-09-28'),
(102, 'Sugerencia', 'Añadir alerta de ruta alternativa en caso de congestión.', '2025-09-29'),
(103, 'Error', 'La ubicación GPS para el accidente 500 no es correcta.', '2025-09-30');


-- Inserción en la tabla Usuarios (se necesita el idRol y, opcionalmente, idReporte)
-- La contraseña se simula como un hash, y la Fecha_registro se autogenera con DEFAULT.
-- --------------------------------------------------------------------------------------------------
INSERT INTO `Usuarios` 
    (`idUsuarios`, `correo`, `contraseña`, `telefono`, `nombre`, `apellido`, `ciudad`, `comuna`, `rut`, `Rol_idRol`, `Reporte_idReporte`, `deleted`) 
VALUES
(1, 'admin@sistemavial.cl', 'hash_admin_123', '987654321', 'Juan', 'Pérez', 'Santiago', 'Providencia', '11.111.111-1', 1, NULL, 0), 
(2, 'inspector1@sistemavial.cl', 'hash_insp_456', '912345678', 'María', 'López', 'Santiago', 'Ñuñoa', '12.222.222-2', 2, 101, 0), 
(3, 'user_a@mail.cl', 'hash_user_a', '955555555', 'Carlos', 'Gómez', 'Valparaíso', 'Viña del Mar', '13.333.333-3', 3, 102, 0), 
(4, 'user_inactivo@mail.cl', 'hash_user_inactivo', '944444444', 'Andrea', 'Muñoz', 'Santiago', 'Las Condes', '14.444.444-4', 3, NULL, 1); -- Usuario INACTIVO

-- Inserción en la tabla Accidente (ya es correcta)
INSERT INTO `Accidente` (`idAccidente`, `descripcion`, `severidad`, `ubicacion`, `tipo_accidente`, `fecha_accidente`, `Usuarios_idUsuarios`, `estado`) VALUES
(201, 'Colisión por alcance en hora punta.', 'Moderado', 'Autopista Central, Km 15', 'Choque', '2025-10-01 08:30:00', 3, 'En Revisión'),
(202, 'Atropello leve por cruce indebido.', 'Leve', 'Calle Huérfanos con Bandera', 'Atropello', '2025-10-01 17:45:00', 2, 'Cerrado'),
(203, 'Accidente grave con volcamiento.', 'Grave', 'Ruta 5 Sur, cerca de Rancagua', 'Volcamiento', '2025-10-02 11:00:00', 3, 'Reportado');

-- Inserción en la tabla Ruta (requiere Accidente_idAccidente)
INSERT INTO `Ruta` (`idRuta`, `nombre_ruta`, `comuna`, `coordenadas`, `Accidente_idAccidente`, `estado`, `descripcion`) VALUES
(301, 'Autopista Central Tramo 15', 'San Bernardo', '-33.567,-70.678', 201, 'Operativo', 'Ruta de alto flujo en la mañana.'),
(302, 'Ruta 5 Sur - Sector Rancagua', 'Rancagua', '-34.170,-70.733', 203, 'Restringido', 'Tramo con alta tasa de accidentes graves.');

-- Inserción en la tabla Leyes_Normas
INSERT INTO `Leyes_Normas` (`id_Ley`, `titulo`, `categoria`, `fecha_publicacion`) VALUES
(401, 'Ley de Tránsito N° 18.290', 'Tránsito', '1984-02-07'),
(402, 'Reglamento de Señalización de Tránsito', 'Infraestructura', '2000-01-15');

-- Inserción en la tabla Auditoria (requiere Usuarios_idUsuarios)
INSERT INTO `Auditoria` (`idAuditoria`, `Usuarios_idUsuarios`, `tipo_evento`, `detalle`) VALUES
(501, 1, 'LOGIN', 'Inicio de sesión exitoso del Administrador.'),
(502, 3, 'INSERT', 'Usuario 3 insertó un nuevo accidente (ID 203).');

-- Inserción en tablas de relación M:M
INSERT INTO `Ruta_has_Usuarios` (`Ruta_idRuta`, `Usuarios_idUsuarios`) VALUES
(301, 2), -- Inspector 2 está asociado a la Ruta 301
(302, 3); -- Usuario 3 está asociado a la Ruta 302

INSERT INTO `Leyes_Normas_has_Usuarios` (`Leyes_Normas_id_Ley`, `Usuarios_idUsuarios`) VALUES
(401, 2), -- Inspector consultó la Ley 18.290
(402, 1); -- Administrador consultó el Reglamento 402



-- SELECT * FROM tabla; para comprobar registros.
SELECT '--- Registros de Rol ---' AS 'Verificación';
SELECT * FROM `Rol`;

SELECT '--- Registros de Usuarios (incluyendo campos de auditoría) ---' AS 'Verificación';
SELECT `idUsuarios`, `nombre`, `apellido`, `correo`, `Rol_idRol`, `created_at`, `deleted` FROM `Usuarios`;

SELECT '--- Registros de Accidente ---' AS 'Verificación';
SELECT `idAccidente`, `severidad`, `estado`, `fecha_accidente`, `descripcion` FROM `Accidente`;

-- 2.2. SELECT * FROM tabla WHERE deleted = 0; para mostrar solo los registros activos.
SELECT '--- Usuarios ACTVOS (deleted = 0) ---' AS 'Verificación de Borrado Lógico';
SELECT `idUsuarios`, `nombre`, `apellido`, `correo` FROM `Usuarios` WHERE `deleted` = 0;

SELECT '--- Rutas ACTIVAS (deleted = 0) ---' AS 'Verificación de Borrado Lógico';
SELECT `idRuta`, `nombre_ruta`, `estado` FROM `Ruta` WHERE `deleted` = 0;


-- Consultas que validen relaciones o condiciones definidas en los CHECK.

-- Consulta para validar la relación (JOIN) entre Accidentes y el Usuario que reportó:
SELECT
    A.`idAccidente`,
    A.`severidad`,
    A.`fecha_accidente`,
    U.`nombre` AS 'Nombre_Reportante',
    U.`apellido` AS 'Apellido_Reportante'
FROM `Accidente` A
JOIN `Usuarios` U ON A.`Usuarios_idUsuarios` = U.`idUsuarios`;

-- Consulta para validar la condición definida en el CHECK de severidad (solo mostrar accidentes Graves o Fatales):
SELECT '--- Accidentes Graves o Fatales (Verificación CHECK) ---' AS 'Verificación de CHECK';
SELECT `idAccidente`, `severidad`, `ubicacion`
FROM `Accidente`
WHERE `severidad` IN ('Grave', 'Fatal');

-- Consulta para validar la condición definida en el CHECK de estado de Reporte:
SELECT '--- Reportes de tipo Queja o Error (Verificación CHECK) ---' AS 'Verificación de CHECK';
SELECT `idReporte`, `tipo_reporte`, `detalle`
FROM `Reporte`
WHERE `tipo_reporte` IN ('Queja', 'Error');
