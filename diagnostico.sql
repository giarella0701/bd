CREATE DATABASE Clinica;
USE Clinica;

CREATE TABLE TipoUsuario (
    tipo_usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE Usuario (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    tipo_usuario_id INT,
    FOREIGN KEY (tipo_usuario_id) REFERENCES TipoUsuario(tipo_usuario_id)
);

CREATE TABLE Paciente (
    paciente_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

CREATE TABLE Medico (
    medico_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    especialidad VARCHAR(100),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

CREATE TABLE Consulta (
    consulta_id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT,
    medico_id INT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    motivo TEXT,
    diagnostico TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(paciente_id),
    FOREIGN KEY (medico_id) REFERENCES Medico(medico_id)
);

CREATE TABLE Tratamiento (
    tratamiento_id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE Cita (
    cita_id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT,
    fecha_solicitud DATE NOT NULL,
    fecha_cita DATE NOT NULL,
    estado VARCHAR(50) NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(paciente_id)
);

INSERT INTO TipoUsuario (descripcion) VALUES 
('Administrador'), 
('Médico'), 
('Paciente'), 
('Recepcionista'), 
('Enfermero');

INSERT INTO Usuario (nombre, correo, telefono, tipo_usuario_id) VALUES 
('Juan Pérez', 'juan@example.com', '123456789', 1),
('María López', 'maria@example.com', '987654321', 2),
('Carlos Gómez', 'carlos@example.com', '555555555', 3),
('Ana Martínez', 'ana@example.com', '111111111', 4),
('Luisa Fernández', 'luisa@example.com', '222222222', 5);

INSERT INTO Paciente (usuario_id) VALUES 
(3), 
(4), 
(5), 
(1), 
(2);

INSERT INTO Medico (usuario_id, especialidad) VALUES 
(2, 'Cardiología'), 
(1, 'Pediatría'), 
(4, 'Dermatología'), 
(5, 'Ortopedia'), 
(3, 'Neurología');

INSERT INTO Consulta (paciente_id, medico_id, fecha, hora, motivo, diagnostico) VALUES 
(1, 2, '2023-10-01', '10:00:00', 'Dolor de pecho', 'Angina de pecho'),
(2, 1, '2023-10-02', '11:00:00', 'Fiebre alta', 'Gripe'),
(3, 4, '2023-10-03', '12:00:00', 'Erupción cutánea', 'Alergia'),
(4, 5, '2023-10-04', '13:00:00', 'Dolor de rodilla', 'Artritis'),
(5, 3, '2023-10-05', '14:00:00', 'Mareos', 'Migraña');

INSERT INTO Tratamiento (descripcion) VALUES 
('Terapia física'), 
('Medicamentos recetados'), 
('Cirugía'), 
('Dieta especial'), 
('Ejercicios de rehabilitación');

INSERT INTO Cita (paciente_id, fecha_solicitud, fecha_cita, estado) VALUES 
(1, '2023-09-25', '2023-10-01', 'Confirmada'),
(2, '2023-09-26', '2023-10-02', 'Pendiente'),
(3, '2023-09-27', '2023-10-03', 'Cancelada'),
(4, '2023-09-28', '2023-10-04', 'Confirmada'),
(5, '2023-09-29', '2023-10-05', 'Pendiente');

SELECT * FROM TipoUsuario;

SELECT * FROM Usuario;

SELECT * FROM Paciente;

SELECT * FROM Medico;

SELECT * FROM Consulta;

UPDATE Usuario 
SET correo = 'nuevo_correo@example.com' 
WHERE usuario_id = 1;

UPDATE Medico 
SET especialidad = 'Oncología' 
WHERE medico_id = 2;

UPDATE Cita 
SET estado = 'Confirmada' 
WHERE cita_id = 2;

DELETE FROM Tratamiento 
WHERE tratamiento_id = 3;