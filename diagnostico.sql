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

