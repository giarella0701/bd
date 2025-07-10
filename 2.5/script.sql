-- Poblar tabla tipo_usuarios
INSERT INTO tipo_usuarios (nombre_tipo, descripcion_tipo, activo, created_by) VALUES -- se agrega el estado de actividad y el creador--
('Administrador', 'Acceso completo al sistema', TRUE, 'sistema '),
('Cliente', 'Usuario con acceso restringido', TRUE, 'sistema '),
('Moderador', 'Puede revisar y aprobar contenido', TRUE, 'sistema');

-- Poblar tabla usuarios
INSERT INTO usuarios (username, password, email, id_tipo_usuario, activo, created_by) VALUES
('admin01', 'pass1234', 'admin01@mail.com', 1, TRUE, 'sistema '),
('jvaldes', 'abc12345', 'jvaldes@mail.com', 2, TRUE, 'sistema '),
('cmorales', '12345476', 'cmorales@mail.com', 3, TRUE, 'sistema '),
('anavarro', 'pass4321', 'anavarro@mail.com', 2, TRUE, 'sistema '),
('rquezada', 'clave2023', 'rquezada@mail.com', 1, TRUE, 'sistema '),
('pgodoy', 'segura123', 'pgodoy@mail.com', 2, TRUE, 'sistema '),
('mdiaz', 'token456', 'mdiaz@mail.com', 3, TRUE, 'sistema '),
('scarvajal', 'azul7819', 'scarvajal@mail.com', 2, TRUE, 'sistema '),
('ltapia', 'lt123783', 'ltapia@mail.com', 3, TRUE, 'sistema '),
('afarias', 'afpass61', 'afarias@mail.com', 2, TRUE, 'sistema ');

-- Poblar tabla ciudad
INSERT INTO ciudad (nombre_ciudad, region, activo, created_by) VALUES
('Santiago', 'Región Metropolitana', TRUE, 'sistema '),
('Valparaíso', 'Región de Valparaíso', TRUE, 'sistema '),
('Concepción', 'Región del Biobío', TRUE, 'sistema '),
('La Serena', 'Región de Coquimbo', TRUE, 'sistema '),
('Puerto Montt', 'Región de Los Lagos', TRUE, 'sistema ');

-- Poblar tabla personas (relacionadas con usuarios y ciudades)
INSERT INTO personas (rut, nombre_completo, fecha_nac, id_usuario, id_ciudad, activo, created_by) VALUES
('11.111.111-1', 'Juan Valdés', '1990-04-12', 2, 1, TRUE, 'sistema '),
('22.222.222-2', 'Camila Morales', '1985-09-25', 3, 2, TRUE, 'sistema '),
('33.333.333-3', 'Andrea Navarro', '1998-11-03', 4, 3, TRUE, 'sistema '),
('44.444.444-4', 'Rodrigo Quezada', '1980-06-17', 5, 1, TRUE, 'sistema '),
('55.555.555-5', 'Patricio Godoy', '1998-12-01', 6, 4, TRUE, 'sistema '),
('66.666.666-6', 'María Díaz', '1987-07-14', 7, 5, TRUE, 'sistema '),
('77.777.777-7', 'Sebastián Carvajal', '1993-03-22', 8, 2, TRUE, 'sistema '),
('88.888.888-8', 'Lorena Tapia', '2000-10-10', 9, 3, TRUE, 'sistema '),
('99.999.999-9', 'Ana Farías', '1995-01-28', 10, 4, TRUE, 'sistema '),
('10.101.010-0', 'Carlos Soto', '1991-08-08', 1, 1, TRUE, 'sistema '); -- admin01


