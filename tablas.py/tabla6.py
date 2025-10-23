# ==========================================
# sp_menu_cambio.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Autor: Giarella
# Propósito: Gestionar cambios de aplicación (insertar, listar, eliminar)
# utilizando procedimientos almacenados y el conector oficial de MySQL.
# ==========================================

import mysql.connector
from datetime import date

# ---------- CONFIGURACIÓN DE CONEXIÓN ----------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1234",          # Cambia según tu configuración
    "database": "sistema_seguridad_vial"  # Cambia por tu base de datos
}

# ---------- FUNCIÓN DE CONEXIÓN ----------
def conectar():
    """Establece conexión con la base de datos MySQL."""
    return mysql.connector.connect(**DB_CONFIG)

# ---------- FUNCIONES PRINCIPALES ----------
def sp_insertar_cambio(usuario_id: int, descripcion: str, version: str, fecha_cambio: date):
    """
    Inserta un nuevo cambio llamando al procedimiento almacenado:
    sp_cambio_insertar(IN p_Usuarios_idUsuarios, IN p_descripcion_cambio, IN p_version_afectada, IN p_fecha_cambio)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_cambio_insertar", [usuario_id, descripcion, version, fecha_cambio])
        cnx.commit()
        print(f"✅ Cambio insertado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar_cambio:", e)
        if cnx and cnx.is_connected():
            try:
                cnx.rollback()
            except:
                pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_cambios_activos():
    """
    Llama al procedimiento almacenado sp_cambio_listar_activos().
    Muestra todos los cambios activos.
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_cambio_listar_activos")

        print("=== CAMBIOS ACTIVOS ===")
        for result in cur.stored_results():
            # Aquí aceptamos 8 columnas (incluyendo deleted)
            for cambio_id, usuario_id, descripcion, version, fecha_cambio, created_at, updated_at, deleted in result.fetchall():
                print(f"ID:{cambio_id:<3} | Usuario:{usuario_id:<3} | Desc:{descripcion:<30} | Versión:{version:<10} | Fecha:{fecha_cambio} | Creado:{created_at} | Actualizado:{updated_at}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_cambios_activos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_borrado_logico_cambio(cambio_id: int):
    """Llama al procedimiento almacenado sp_cambio_borrado_logico(IN p_cambio_id)."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_cambio_borrado_logico", [cambio_id])
        cnx.commit()
        print(f"✅ Cambio ID {cambio_id} marcado como eliminado (borrado lógico).")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico_cambio:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------------- MENÚ PRINCIPAL ----------------
def menu():
    """Muestra un menú interactivo en consola para gestionar los cambios."""
    while True:
        print("|-----------------------------------------------|")
        print("|         MENÚ CAMBIOS APLICACIÓN              |")
        print("|-----------------------------------------------|")
        print("| 1) Ingresar nuevo cambio                      |")
        print("| 2) Listar cambios activos                     |")
        print("| 3) Borrado lógico por ID                      |")
        print("| 0) Salir                                     |")
        print("|-----------------------------------------------|")
        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            try:
                usuario_id = int(input("ID del usuario que aplica el cambio: ").strip())
                descripcion = input("Descripción del cambio: ").strip()
                version = input("Versión afectada: ").strip()
                fecha_input = input("Fecha de cambio (AAAA-MM-DD): ").strip()
                fecha_cambio = date.fromisoformat(fecha_input)
                sp_insertar_cambio(usuario_id, descripcion, version, fecha_cambio)
            except ValueError:
                print("❌ Datos inválidos. Revisa el ID o la fecha.")
        elif opcion == "2":
            sp_listar_cambios_activos()
        elif opcion == "3":
            try:
                cambio_id = int(input("ID del cambio a eliminar: ").strip())
                sp_borrado_logico_cambio(cambio_id)
            except ValueError:
                print("❌ ID inválido.")
        elif opcion == "0":
            print("👋 Saliendo del sistema...")
            break
        else:
            print("❌ Opción no válida.")

# ---------- PUNTO DE ENTRADA ----------
if __name__ == "__main__":
    menu()
