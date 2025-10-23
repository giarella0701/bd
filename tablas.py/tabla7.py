# ==========================================
# sp_ruta_usuario.py
# CRUD básico para la tabla Ruta_has_Usuarios
# Autor: Giarella
# ==========================================

import mysql.connector

# ---------- CONFIGURACIÓN DE CONEXIÓN ----------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1234",
    "database": "sistema_seguridad_vial"
}

# ---------- FUNCIÓN DE CONEXIÓN ----------
def conectar():
    return mysql.connector.connect(**DB_CONFIG)

# ---------- FUNCIONES PRINCIPALES ----------
def sp_ruta_usuario_insertar(id_ruta: int, id_usuario: int):
    """Inserta una relación Ruta-Usuario si no existe y si ambos existen."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()

        # Verificar que la ruta exista
        cur.execute("SELECT COUNT(*) FROM Ruta WHERE idRuta=%s AND deleted=0", (id_ruta,))
        if cur.fetchone()[0] == 0:
            print(f"❌ La ruta con ID {id_ruta} no existe.")
            return

        # Verificar que el usuario exista
        cur.execute("SELECT COUNT(*) FROM Usuarios WHERE idUsuarios=%s AND deleted=0", (id_usuario,))
        if cur.fetchone()[0] == 0:
            print(f"❌ El usuario con ID {id_usuario} no existe.")
            return

        # Verificar que no exista la relación
        cur.execute("SELECT COUNT(*) FROM Ruta_has_Usuarios WHERE Ruta_idRuta=%s AND Usuarios_idUsuarios=%s",
                    (id_ruta, id_usuario))
        if cur.fetchone()[0] > 0:
            print("❌ La relación Ruta-Usuario ya existe.")
            return

        # Insertar relación
        cur.execute(
            "INSERT INTO Ruta_has_Usuarios (Ruta_idRuta, Usuarios_idUsuarios) VALUES (%s, %s)",
            (id_ruta, id_usuario)
        )
        cnx.commit()
        print(f"✅ Relación Ruta {id_ruta} - Usuario {id_usuario} insertada correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_ruta_usuario_insertar:", e)
        if cnx and cnx.is_connected():
            cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_ruta_usuarios():
    """Lista todas las relaciones Ruta-Usuario."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("""
            SELECT ru.Ruta_idRuta, r.nombre_ruta, ru.Usuarios_idUsuarios, u.nombre, u.apellido
            FROM Ruta_has_Usuarios ru
            INNER JOIN Ruta r ON ru.Ruta_idRuta = r.idRuta
            INNER JOIN Usuarios u ON ru.Usuarios_idUsuarios = u.idUsuarios
            ORDER BY ru.Ruta_idRuta, ru.Usuarios_idUsuarios
        """)
        print("=== RELACIONES RUTA - USUARIO ===")
        rows = cur.fetchall()
        if not rows:
            print("No hay relaciones registradas.")
        for ruta_id, nombre_ruta, usuario_id, nombre, apellido in rows:
            print(f"Ruta ID:{ruta_id:<3} ({nombre_ruta:<15}) | Usuario ID:{usuario_id:<3} ({nombre} {apellido})")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_ruta_usuarios:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------------- MENÚ PRINCIPAL ----------------
def menu():
    while True:
        print("|--------------------------------------------|")
        print("|       MENÚ RUTA - USUARIOS (SP)           |")
        print("|--------------------------------------------|")
        print("| 1) Insertar relación Ruta-Usuario         |")
        print("| 2) Listar relaciones Ruta-Usuario         |")
        print("| 0) Salir                                  |")
        print("|--------------------------------------------|")
        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            try:
                id_ruta = int(input("ID de la ruta: ").strip())
                id_usuario = int(input("ID del usuario: ").strip())
                sp_ruta_usuario_insertar(id_ruta, id_usuario)
            except ValueError:
                print("❌ IDs inválidos.")
        elif opcion == "2":
            sp_listar_ruta_usuarios()
        elif opcion == "0":
            print("👋 Saliendo...")
            break
        else:
            print("❌ Opción no válida.")

# ---------- PUNTO DE ENTRADA ----------
if __name__ == "__main__":
    menu()
