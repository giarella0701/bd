CREATE DATABASE IF NOT EXISTS sistema_ventas_4c;
USE sistema_ventas_4c;

-- -----------------------------------------------------
-- Table tipo_usuarios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tipo_usuarios (
  id INT NOT NULL AUTO_INCREMENT,
  nombre_tipo VARCHAR(50) NOT NULL,
  created_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by INT NULL DEFAULT NULL,
  updated_by INT NULL DEFAULT NULL,
  deleted TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table usuarios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) NULL DEFAULT NULL,
  password VARCHAR(100) NULL DEFAULT NULL,
  tipo_usuario_id INT NULL DEFAULT NULL,
  created_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by INT NULL DEFAULT NULL,
  updated_by INT NULL DEFAULT NULL,
  deleted TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY (correo),
  CONSTRAINT fk_usuario_tipo_usuario FOREIGN KEY (tipo_usuario_id)
    REFERENCES tipo_usuarios (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table productos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS productos (
  id INT NOT NULL AUTO_INCREMENT,
  nombre_productos VARCHAR(100) NULL DEFAULT NULL,
  descripcion VARCHAR(300) NULL DEFAULT NULL,
  precio_productos DECIMAL(10,2) NULL DEFAULT NULL,
  stock_productos INT NULL DEFAULT NULL,
  created_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by INT NULL DEFAULT NULL,
  updated_by INT NULL DEFAULT NULL,
  deleted TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table ventas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas (
  id INT NOT NULL AUTO_INCREMENT,
  usuario_id INT NULL DEFAULT NULL,
  fecha DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by INT NULL DEFAULT NULL,
  updated_by INT NULL DEFAULT NULL,
  deleted TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT fk_venta_usuario FOREIGN KEY (usuario_id)
    REFERENCES usuarios (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table detalle_ventas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS detalle_ventas (
  id INT NOT NULL AUTO_INCREMENT,
  venta_id INT NULL DEFAULT NULL,
  producto_id INT NULL DEFAULT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  updated_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by INT NULL DEFAULT NULL,
  updated_by INT NULL DEFAULT NULL,
  deleted TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT fk_detalle_venta FOREIGN KEY (venta_id)
    REFERENCES ventas (id),
  CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_id)
    REFERENCES productos (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------

-- -----------------------------------------------------
INSERT INTO tipo_usuarios (nombre_tipo, created_by, updated_by) VALUES
('Administrador', NULL, NULL),
('Vendedor', NULL, NULL),
('Cliente', NULL, NULL),
('Soporte Tecnico', NULL, NULL);

-- -----------------------------------------------------

-- -----------------------------------------------------
INSERT INTO usuarios (nombre, correo, password, tipo_usuario_id, created_by, updated_by) VALUES
('sistema', 'sistema@plataforma.cl', '$2y$10$2pEjT0G2k9YzHs1oZ.abcde3Y8GkmHfvhO1/abcxyz', 1, NULL, NULL),
('carla.rios', 'carla.rios@empresa.cl', '$2y$10$7oTi7cJbKN1kP0AcjBqXrOXeZ3SKxmcY5H8k5UmUO1bUNsEQ6hnvi', 3, 1, 1),
('luis.gonzalez', 'luis.gonzalez@empresa.cl', '$2y$10$MnZwE1jz9u5L1hFVcX3eKuep6R7HGgW1zKHPuL32P3oyz7pQAZFaK', 4, 1, 1),
('marcela.torres', 'marcela.torres@empresa.cl', '$2y$10$GpVCzKtF/9vK6hAGTp6v/etOHezE0aWXI6fJoOYKOlm8MxUvOh8xa', 1, 1, 1);

-- -----------------------------------------------------

-- -----------------------------------------------------
INSERT INTO productos (nombre_productos, descripcion, precio_productos, stock_productos, created_at, updated_at, created_by, updated_by, deleted) VALUES
('Mouse inalámbrico Logitech M185', 'Mouse compacto, conexión inalámbrica 2.4GHz, compatible con Windows y macOS.', 12990, 35, NOW(), NOW(), 1, 1, 0),
('Teclado mecánico Redragon Kumara K552', 'Teclado mecánico compacto con retroiluminación LED roja, switches Outemu Blue.', 34990, 20, NOW(), NOW(), 1, 1, 0),
('Monitor Samsung 24\" FHD IPS', 'Monitor de 24 pulgadas, resolución Full HD (1920x1080), panel IPS, puerto HDMI.', 119990, 12, NOW(), NOW(), 1, 1, 0);

-- -----------------------------------------------------

-- -----------------------------------------------------
INSERT INTO ventas (usuario_id, fecha, created_by, updated_by) VALUES
(2, '2025-05-29 10:32:00', 1, 1),
(3, '2025-05-29 14:47:00', 1, 1);

-- -----------------------------------------------------

-- -----------------------------------------------------
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, created_by, updated_by) VALUES
(1, 1, 1, 12990, 1, 1),
(1, 2, 2, 34990, 1, 1),
(2, 3, 1, 119990, 1, 1),
(2, 1, 1, 12990, 1, 1);

-- -----------------------------------------------------

-- -----------------------------------------------------
INSERT INTO usuarios (nombre, correo, password, tipo_usuario_id, created_at, updated_at, deleted) VALUES
('Claudia Torres', 'claudia.torres@empresa.cl', 'claudia123', 2, '2025-05-12 10:00:00', '2025-05-12 10:00:00', 0),
('Juan González', 'juan.gonzalez@empresa.cl', 'juan123', 3, '2025-05-15 09:30:00', '2025-05-15 09:30:00', 0),
('Mario Vargas', 'mario.vargas@gmail.com', 'mario123', 2, '2025-03-20 12:00:00', '2025-03-20 12:00:00', 1),
('Laura Torres', 'laura.t@otrocorreo.com', 'laura123', 4, '2025-01-25 15:00:00', '2025-02-01 15:30:00', 0),
('Pedro Rojas', 'pedro@empresa.cl', 'pedro123', 1, '2024-12-11 14:00:00', '2025-01-01 08:45:00', 0),
('Marcela Paredes', 'marcela@empresa.cl', 'marcela123', 2, '2025-05-04 11:00:00', '2025-05-04 11:30:00', 0),
('Carlos Bravo', 'carlosb@empresa.cl', 'carlos123', 3, '2025-04-29 16:00:00', '2025-04-30 10:00:00', 1),
('Ana González', 'ana.gonzalez@correo.com', 'ana123', 4, '2025-05-02 10:00:00', '2025-05-02 10:15:00', 0),
('Luis Torres', 'luis.torres@empresa.cl', 'luis123', 2, '2025-05-01 09:00:00', '2025-05-01 09:10:00', 0);



DELETE FROM usuarios WHERE correo = 'claudia.torres@empresa.cl';


SELECT u.*
FROM usuarios u
JOIN tipo_usuarios tu ON u.tipo_usuario_id = tu.id
WHERE tu.nombre_tipo = 'Administrador';


SELECT * FROM usuarios WHERE deleted = 0;


SELECT nombre, created_at
FROM usuarios
WHERE created_at BETWEEN '2025-05-01' AND '2025-05-31';


SELECT nombre, correo
FROM usuarios
WHERE deleted = 0 AND tipo_usuario_id = 2;


SELECT nombre, correo
FROM usuarios
WHERE correo LIKE '%@empresa.cl';


SELECT nombre, tipo_usuario_id, deleted
FROM usuarios
WHERE deleted = 1 AND tipo_usuario_id IN (3, 4);


SELECT nombre, correo
FROM usuarios
WHERE nombre LIKE '%Torres%' OR nombre LIKE '%González%';
