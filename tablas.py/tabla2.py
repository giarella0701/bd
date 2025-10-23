# ==========================================
# sp_menu_usuarios.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Autor: Giarella
# Propósito: Gestionar usuarios (insertar, listar, eliminar)
# utilizando procedimientos almacenados y el conector oficial de MySQL.
# ==========================================

import mysql.connector
from getpass import getpass
import hashlib

# ---------- CONFIGURACIÓN DE CONEXIÓN ----------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1234",  # Cambia según tu configuración
    "database": "sistema_seguridad_vial"
}

# ---------- FUNCIÓN DE CONEXIÓN ----------
def conectar():
    """Establece conexión con la base de datos MySQL."""
    return mysql.connector.connect(**DB_CONFIG)

# ---------- FUNCIONES PRINCIPALES ----------
def sp_insertar_usuario(correo, contraseña, telefono, nombre, apellido, ciudad, comuna, rut, Rol_idRol):
    """
    Inserta un nuevo usuario llamando al procedimiento almacenado sp_usuarios_insertar.
    La contraseña debe ingresarse en texto plano; aquí la hasheamos antes de guardar.
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()

        # Hasheamos la contraseña con SHA256
        hash_contraseña = hashlib.sha256(contraseña.encode()).hexdigest()

        args = [correo, hash_contraseña, telefono, nombre, apellido, ciudad, comuna, rut, Rol_idRol]
        cur.callproc("sp_usuarios_insertar", args)
        cnx.commit()
        print(f"✅ Usuario {nombre} {apellido} insertado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar_usuario:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_listar_usuarios_activos():
    """Lista todos los usuarios activos usando sp_usuarios_listar_activos."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_usuarios_listar_activos")
        print("=== USUARIOS ACTIVOS ===")
        for result in cur.stored_results():
            for (idUsuarios, correo, telefono, nombre, apellido, rut, rol_asignado, Fecha_registro) in result.fetchall():
                tel = telefono if telefono else "-"
                print(f"ID:{idUsuarios:<3} | {nombre} {apellido:<20} | Correo:{correo:<25} | Tel:{tel:<12} | "
                    f"RUT:{rut:<12} | Rol:{rol_asignado:<15} | Fecha registro:{Fecha_registro}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_usuarios_activos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_borrado_logico_usuario(idUsuarios: int):
    """Aplica borrado lógico a un usuario llamando a sp_usuarios_borrado_logico."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_usuarios_borrado_logico", [idUsuarios])
        cnx.commit()
        print(f"✅ Usuario ID {idUsuarios} marcado como eliminado (borrado lógico).")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico_usuario:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------------- MENÚ PRINCIPAL ----------------
def menu():
    """Menú interactivo en consola para gestionar usuarios."""
    while True:
        print("\n===== MENÚ USUARIOS (MySQL + SP) =====")
        print("1) Insertar usuario")
        print("2) Listar usuarios ACTIVOS")
        print("3) Borrado lógico por ID")
        print("0) Salir")
        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            correo = input("Correo: ").strip()
            contraseña = getpass("Contraseña: ").strip()
            telefono = input("Teléfono (opcional): ").strip() or None
            nombre = input("Nombre: ").strip()
            apellido = input("Apellido: ").strip()
            ciudad = input("Ciudad (opcional): ").strip() or None
            comuna = input("Comuna (opcional): ").strip() or None
            rut = input("RUT: ").strip()
            try:
                Rol_idRol = int(input("ID del rol asignado: ").strip())
            except ValueError:
                print("❌ ID de rol inválido.")
                continue
            sp_insertar_usuario(correo, contraseña, telefono, nombre, apellido, ciudad, comuna, rut, Rol_idRol)

        elif opcion == "2":
            sp_listar_usuarios_activos()

        elif opcion == "3":
            try:
                idu = int(input("ID del usuario a eliminar: ").strip())
                sp_borrado_logico_usuario(idu)
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
