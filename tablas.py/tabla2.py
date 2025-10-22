import mysql.connector
from mysql.connector import errorcode

# Configuración de conexión
config = {
    'user': 'root',           # Cambia por tu usuario MySQL
    'password': '',           # Cambia por tu contraseña MySQL
    'host': 'localhost',
    'database': 'nombre_basedatos',  # Cambia por el nombre de tu base de datos
    'raise_on_warnings': True
}

# Sentencia SQL para crear la tabla Usuarios
TABLES = {}
TABLES['Usuarios'] = (
    """
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
    
    `Reporte_idReporte` INT NULL COMMENT 'ID del último reporte asociado al usuario (opcional).',
    `Rol_idRol` INT NOT NULL COMMENT 'ID del Rol asignado al usuario (e.g., 1=General, 2=Inspector).',

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
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT `fk_Usuarios_Rol1`
        FOREIGN KEY (`Rol_idRol`)
        REFERENCES `Rol` (`idRol`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
    ) ENGINE = InnoDB COMMENT = 'Tabla principal de Usuarios.';
    """
)

try:
    # Conexión a MySQL
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor()
    print("Conexión establecida correctamente ✅")

    # Crear tabla Usuarios
    for table_name in TABLES:
        table_description = TABLES[table_name]
        try:
            print(f"Creando tabla `{table_name}`...")
            cursor.execute(table_description)
            print("✅ Tabla creada correctamente.")
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
                print("⚠️ La tabla ya existe.")
            else:
                print(err.msg)
        else:
            print("OK")

    cursor.close()
    cnx.close()

except mysql.connector.Error as err:
    print(f"❌ Error de conexión: {err}")
