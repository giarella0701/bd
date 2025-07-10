CREATE DATABASE ejemplo_Select;
USE ejemplo_Select;

-- Tabla: tipo_usuarios
CREATE TABLE tipo_usuarios (
    id_tipo INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    nombre_tipo VARCHAR(50) NOT NULL, 
    descripcion_tipo VARCHAR(200) NOT NULL,
    activo BOOLEAN DEFAULT TRUE, -- Indica si esta activo--
	created_by VARCHAR (50), -- usuario que creó el registro--
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- fecha de creacion--
    CHECK (CHAR_LENGTH(nombre_tipo) >= 3) -- valida que el nombre tenga mas de 3 caracteres--
);

-- Tabla: usuarios (se añade campo created_at con valor por defecto)
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(200) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_tipo_usuario INT,
	activo BOOLEAN DEFAULT TRUE,   -- Indica si esta activo--
    created_by VARCHAR (50),  -- usuario que creó el registro--
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- fecha de actulizacion--
    CHECK (CHAR_LENGTH(password) >= 8) , -- valida que la contraseña tenga mas de 8 caracteres--
    CONSTRAINT fk_usuarios_tipo_usuarios FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuarios(id_tipo)
);

-- Tabla: ciudad (nueva)
CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,  -- Indica si esta activo--
    created_by VARCHAR (50), -- usuario que creó el registro--
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- fecha de creacion--
    CHECK (nombre_ciudad <> '') -- valida que el campo nombre_ciudad no este vacio--
);

-- Tabla: personas (relacionada con usuarios y ciudad)
CREATE TABLE personas (
    rut VARCHAR(13) NOT NULL UNIQUE,
    nombre_completo VARCHAR(100) NOT NULL,
    fecha_nac DATE,
    id_usuario INT,
    id_ciudad INT,
	activo BOOLEAN DEFAULT TRUE,  -- Indica si esta activo--
    created_by VARCHAR (50), -- usuario que creó el registro--
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,-- fecha de creacion--
    CHECK (CHAR_LENGTH(nombre_completo) >= 5), -- valida que el nombre completo tenga mas de 5 caracteres--
    CONSTRAINT fk_personas_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_personas_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);