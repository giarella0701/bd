-- SCRIPT 1: CREACIÓN DE LA BASE DE DATOS Y TABLAS
-- Archivo: creacion_db.sql

-- Se establece el modo SQL para asegurar la compatibilidad y el comportamiento estricto.
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Creación del Esquema (Base de Datos)
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sistema_seguridad_vial` DEFAULT CHARACTER SET utf8mb4 ;
USE `sistema_seguridad_vial` ;

-- -----------------------------------------------------
-- Table `Rol`
-- Descripción: Almacena los roles de los usuarios (e.g., Administrador, Inspector, Usuario General).
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Rol` (
  `idRol` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único del rol.',
  `nombre_rol` VARCHAR(45) NOT NULL UNIQUE COMMENT 'Nombre único del rol.',
  -- Campos de Auditoría
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico (0=Activo, 1=Inactivo).',
  PRIMARY KEY (`idRol`)
) ENGINE = InnoDB COMMENT = 'Tabla de Roles de Usuario.';


-- -----------------------------------------------------
-- Table `Reporte`
-- Descripción: Almacena reportes de incidentes, quejas o sugerencias.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Reporte` (
  `idReporte` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único del reporte.',
  `tipo_reporte` VARCHAR(45) NOT NULL COMMENT 'Categoría del reporte (e.g., Queja, Sugerencia, Error).',
  `detalle` TEXT NULL COMMENT 'Descripción detallada del reporte.',
  `fecha_reporte` DATE NOT NULL COMMENT 'Fecha en que se generó el reporte.',
  -- Columna extra 'Reportecol' eliminada por no ser clara su función.
  -- Campos de Auditoría
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico.',
  PRIMARY KEY (`idReporte`),
  -- Restricción CHECK: Asegura que el tipo de reporte sea uno de los valores permitidos.
  CONSTRAINT `chk_tipo_reporte` CHECK (`tipo_reporte` IN ('Queja', 'Sugerencia', 'Error', 'Otro'))
) ENGINE = InnoDB COMMENT = 'Tabla de Reportes del Sistema.';


-- -----------------------------------------------------
-- Table `Usuarios`
-- Descripción: Almacena la información de los usuarios del sistema.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Usuarios` (
  `idUsuarios` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único del usuario.',
  `correo` VARCHAR(100) NOT NULL UNIQUE COMMENT 'Correo electrónico único del usuario.',
  `contraseña` VARCHAR(255) NOT NULL COMMENT 'Contraseña hasheada del usuario.',
  `telefono` VARCHAR(20) NULL COMMENT 'Número de teléfono del usuario.',
  `nombre` VARCHAR(45) NOT NULL COMMENT 'Primer nombre del usuario.',
  `apellido` VARCHAR(45) NOT NULL COMMENT 'Apellido del usuario.',
  `ciudad` VARCHAR(45) NULL COMMENT 'Ciudad de residencia.',
  `comuna` VARCHAR(45) NULL COMMENT 'Comuna de residencia.',
  `rut` VARCHAR(12) NOT NULL UNIQUE COMMENT 'RUT (o DNI) único del usuario.',
  `Fecha_registro` DATE DEFAULT (CURRENT_DATE()) COMMENT 'Fecha en la que el usuario se registró.',
  
  -- Llaves Foráneas
  `Reporte_idReporte` INT NULL COMMENT 'ID del último reporte asociado al usuario (Opcional, podría ser una tabla intermedia).',
  `Rol_idRol` INT NOT NULL COMMENT 'ID del Rol asignado al usuario (e.g., 1=General, 2=Inspector).',
  
  -- Campos de Auditoría
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico.',
  PRIMARY KEY (`idUsuarios`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC) VISIBLE,
  UNIQUE INDEX `rut_UNIQUE` (`rut` ASC) VISIBLE,
  
  INDEX `fk_Usuarios_Reporte1_idx` (`Reporte_idReporte` ASC) VISIBLE,
  INDEX `fk_Usuarios_Rol1_idx` (`Rol_idRol` ASC) VISIBLE,
  
  CONSTRAINT `fk_Usuarios_Reporte1`
    FOREIGN KEY (`Reporte_idReporte`)
    REFERENCES `Reporte` (`idReporte`)
    ON DELETE SET NULL -- Mejor SET NULL si el reporte se elimina, o cambiar la FK.
    ON UPDATE CASCADE,
    
  CONSTRAINT `fk_Usuarios_Rol1`
    FOREIGN KEY (`Rol_idRol`)
    REFERENCES `Rol` (`idRol`)
    ON DELETE RESTRICT -- No permitir eliminar un Rol si hay usuarios asociados.
    ON UPDATE CASCADE
) ENGINE = InnoDB COMMENT = 'Tabla principal de Usuarios.';


-- -----------------------------------------------------
-- Table `Accidente`
-- Descripción: Almacena los detalles de los accidentes reportados.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Accidente` (
  `idAccidente` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único del accidente.',
  `descripcion` TEXT NULL COMMENT 'Descripción detallada del accidente.',
  `severidad` VARCHAR(45) NOT NULL COMMENT 'Nivel de gravedad del accidente (e.g., Leve, Moderado, Grave).',
  `ubicacion` VARCHAR(255) NOT NULL COMMENT 'Dirección o referencia de la ubicación del accidente.',
  `tipo_accidente` VARCHAR(45) NULL COMMENT 'Clasificación del accidente (e.g., Choque, Atropello, Deslizamiento).',
  `fecha_accidente` DATETIME NOT NULL COMMENT 'Fecha y hora exacta del accidente.',
  `estado` VARCHAR(45) NOT NULL DEFAULT 'Reportado' COMMENT 'Estado actual del caso (e.g., Reportado, En Revisión, Cerrado).',
  
  -- Llave Foránea
  `Usuarios_idUsuarios` INT NOT NULL COMMENT 'ID del usuario que reportó el accidente.',
  
  -- Campos de Auditoría
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico.',
  PRIMARY KEY (`idAccidente`),
  
  INDEX `fk_Accidente_Usuarios1_idx` (`Usuarios_idUsuarios` ASC) VISIBLE,
  
  CONSTRAINT `fk_Accidente_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuarios`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE RESTRICT -- No se debe eliminar el usuario si tiene accidentes asociados.
    ON UPDATE CASCADE,
    
  -- Restricción CHECK: Asegura que la severidad sea uno de los valores definidos.
  CONSTRAINT `chk_severidad` CHECK (`severidad` IN ('Leve', 'Moderado', 'Grave', 'Fatal')),
  
  -- Restricción CHECK: Asegura que el estado sea uno de los valores definidos.
  CONSTRAINT `chk_estado_accidente` CHECK (`estado` IN ('Reportado', 'En Revisión', 'Cerrado', 'Archivado'))
) ENGINE = InnoDB COMMENT = 'Tabla de Accidentes Reportados.';


-- -----------------------------------------------------
-- Table `Ruta`
-- Descripción: Almacena información sobre rutas relevantes o afectadas por accidentes.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ruta` (
  `idRuta` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único de la ruta.',
  `nombre_ruta` VARCHAR(45) NOT NULL COMMENT 'Nombre o código de la ruta.',
  `comuna` VARCHAR(45) NULL COMMENT 'Comuna por la que pasa la ruta.',
  `coordenadas` VARCHAR(100) NULL COMMENT 'Coordenadas GPS de un punto clave o tramo de la ruta.',
  `estado` VARCHAR(45) NOT NULL DEFAULT 'Operativo' COMMENT 'Estado de la ruta (e.g., Operativo, En Mantenimiento, Cerrado).',
  `descripcion` TEXT NULL COMMENT 'Descripción general o notas sobre la ruta.',
  
  -- Llave Foránea
  `Accidente_idAccidente` INT NOT NULL COMMENT 'ID del accidente que se registró en o afectó esta ruta.',
  
  -- Campos de Auditoría
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico.',
  PRIMARY KEY (`idRuta`),
  
  INDEX `fk_Ruta_Accidente1_idx` (`Accidente_idAccidente` ASC) VISIBLE,
  
  CONSTRAINT `fk_Ruta_Accidente1`
    FOREIGN KEY (`Accidente_idAccidente`)
    REFERENCES `Accidente` (`idAccidente`)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE,
    
  -- Restricción CHECK: Estado de la ruta.
  CONSTRAINT `chk_estado_ruta` CHECK (`estado` IN ('Operativo', 'En Mantenimiento', 'Cerrado', 'Restringido'))
) ENGINE = InnoDB COMMENT = 'Tabla de Rutas y su relación con Accidentes.';


-- -----------------------------------------------------
-- Table `Leyes_Normas`
-- Descripción: Catálogo de leyes y normas de seguridad vial.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Leyes_Normas` (
  `id_Ley` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único de la ley/norma.',
  `titulo` VARCHAR(255) NOT NULL UNIQUE COMMENT 'Título o nombre de la ley/norma.',
  `categoria` VARCHAR(45) NULL COMMENT 'Categoría a la que pertenece (e.g., Tránsito, Infraestructura).',
  `fecha_publicacion` DATE NULL COMMENT 'Fecha de publicación oficial.',
  
  -- Campos de Auditoría
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico.',
  PRIMARY KEY (`id_Ley`)
) ENGINE = InnoDB COMMENT = 'Tabla de Leyes y Normas de Seguridad Vial.';


-- -----------------------------------------------------
-- Table `Auditoria`
-- Descripción: Registra eventos importantes en el sistema para fines de auditoría.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Auditoria` (
  `idAuditoria` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único del registro de auditoría.',
  `Usuarios_idUsuarios` INT NOT NULL COMMENT 'ID del usuario que realizó el evento.',
  `tipo_evento` VARCHAR(45) NOT NULL COMMENT 'Tipo de acción (e.g., LOGIN, INSERT, UPDATE, DELETE).',
  `detalle` TEXT NULL COMMENT 'Descripción detallada de la acción realizada.',
  `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del evento.',
  
  -- Campos de Auditoría (Se mantienen por consistencia, aunque esta tabla es en sí de auditoría)
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico (poco común en auditoría, pero se mantiene).',
  PRIMARY KEY (`idAuditoria`),
  
  INDEX `fk_Auditoria_Usuarios1_idx` (`Usuarios_idUsuarios` ASC) VISIBLE,
  
  CONSTRAINT `fk_Auditoria_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuarios`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB COMMENT = 'Tabla de Registros de Auditoría del Sistema.';


-- -----------------------------------------------------
-- Table `Cambio_Aplicacion`
-- Descripción: Registra los cambios realizados en la aplicación (versiones, funcionalidades).
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cambio_Aplicacion` (
  `cambio_id` INT NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria, identificador único del cambio.',
  `Usuarios_idUsuarios` INT NOT NULL COMMENT 'ID del usuario (desarrollador/administrador) que aplicó el cambio.',
  `descripcion_cambio` TEXT NOT NULL COMMENT 'Detalle del cambio realizado.',
  `version_afectada` VARCHAR(45) NULL COMMENT 'Versión de la aplicación a la que aplica el cambio.',
  `fecha_cambio` DATE NOT NULL COMMENT 'Fecha en que se implementó el cambio.',
  
  -- Campos de Auditoría
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro.',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última modificación del registro.',
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indicador de borrado lógico.',
  PRIMARY KEY (`cambio_id`),
  
  INDEX `fk_Cambio_Aplicacion_Usuarios1_idx` (`Usuarios_idUsuarios` ASC) VISIBLE,
  
  CONSTRAINT `fk_Cambio_Aplicacion_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuarios`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB COMMENT = 'Tabla de Historial de Cambios de la Aplicación.';


-- -----------------------------------------------------
-- Table `Ruta_has_Usuarios` (Relación M:M entre Ruta y Usuarios)
-- Descripción: Indica qué usuarios están asociados o han interactuado con ciertas rutas.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ruta_has_Usuarios` (
  `Ruta_idRuta` INT NOT NULL COMMENT 'Clave Foránea a la tabla Ruta.',
  `Usuarios_idUsuarios` INT NOT NULL COMMENT 'Clave Foránea a la tabla Usuarios.',
  PRIMARY KEY (`Ruta_idRuta`, `Usuarios_idUsuarios`),
  
  INDEX `fk_Ruta_has_Usuarios_Usuarios1_idx` (`Usuarios_idUsuarios` ASC) VISIBLE,
  INDEX `fk_Ruta_has_Usuarios_Ruta1_idx` (`Ruta_idRuta` ASC) VISIBLE,
  
  CONSTRAINT `fk_Ruta_has_Usuarios_Ruta1`
    FOREIGN KEY (`Ruta_idRuta`)
    REFERENCES `Ruta` (`idRuta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
  CONSTRAINT `fk_Ruta_has_Usuarios_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuarios`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB COMMENT = 'Tabla de Asociación entre Rutas y Usuarios.';


-- -----------------------------------------------------
-- Table `Leyes_Normas_has_Usuarios` (Relación M:M entre Leyes_Normas y Usuarios)
-- Descripción: Registra qué usuarios han consultado o están asociados a ciertas leyes/normas.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Leyes_Normas_has_Usuarios` (
  `Leyes_Normas_id_Ley` INT NOT NULL COMMENT 'Clave Foránea a la tabla Leyes_Normas.',
  `Usuarios_idUsuarios` INT NOT NULL COMMENT 'Clave Foránea a la tabla Usuarios.',
  PRIMARY KEY (`Leyes_Normas_id_Ley`, `Usuarios_idUsuarios`),
  
  INDEX `fk_Leyes_Normas_has_Usuarios_Usuarios1_idx` (`Usuarios_idUsuarios` ASC) VISIBLE,
  INDEX `fk_Leyes_Normas_has_Usuarios_Leyes_Normas1_idx` (`Leyes_Normas_id_Ley` ASC) VISIBLE,
  
  CONSTRAINT `fk_Leyes_Normas_has_Usuarios_Leyes_Normas1`
    FOREIGN KEY (`Leyes_Normas_id_Ley`)
    REFERENCES `Leyes_Normas` (`id_Ley`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
  CONSTRAINT `fk_Leyes_Normas_has_Usuarios_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuarios`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB COMMENT = 'Tabla de Asociación entre Leyes/Normas y Usuarios.';


-- Se restablecen las configuraciones iniciales.
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
