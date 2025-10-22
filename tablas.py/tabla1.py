# ==========================================
# sp_menu_rol.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Autor: Giarella
# Propósito: Gestionar roles de usuario (insertar, listar, eliminar y restaurar)
# utilizando procedimientos almacenados y el conector oficial de MySQL.
# ==========================================

import mysql.connector

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
def sp_insertar(nombre_rol: str) -> int:
    """
    Inserta un nuevo rol llamando al procedimiento almacenado:
    sp_insertar_rol(IN p_nombre_rol, OUT p_nuevo_id)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        args = [nombre_rol, 0]  # OUT parameter al final
        args = cur.callproc("sp_insertar_rol", args)
        cnx.commit()
        nuevo_id = args[1]
        print(f"✅ Rol insertado correctamente. Nuevo ID: {nuevo_id}")
        return nuevo_id
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar:", e)
        if cnx and cnx.is_connected():
            try:
                cnx.rollback()
            except:
                pass
        return -1
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_listar_activos():
    """
    Llama al procedimiento almacenado sp_listar_roles_activos().
    Muestra todos los roles con deleted = 0.
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_roles_activos")

        print("=== ROLES ACTIVOS ===")
        for result in cur.stored_results():
            for (idRol, nombre_rol, created_at, updated_at) in result.fetchall():
                ua = updated_at if updated_at else "-"
                print(f"ID:{idRol:<3} | Nombre:{nombre_rol:<15} | Creado:{created_at} | Actualizado:{ua}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_activos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_listar_todos():
    """
    Llama al procedimiento almacenado sp_listar_roles_todos().
    Muestra todos los roles, incluyendo los eliminados.
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_roles_todos")

        print("=== ROLES (TODOS) ===")
        for result in cur.stored_results():
            for (idRol, nombre_rol, deleted, created_at, updated_at) in result.fetchall():
                estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
                ua = updated_at if updated_at else "-"
                print(f"ID:{idRol:<3} | Nombre:{nombre_rol:<15} | Estado:{estado:<9} | Creado:{created_at} | Actualizado:{ua}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_todos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_borrado_logico(idRol: int):
    """Llama al procedimiento almacenado sp_borrado_logico_rol(IN p_idRol)."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_borrado_logico_rol", [idRol])
        cnx.commit()
        print(f"✅ Rol ID {idRol} marcado como eliminado (borrado lógico).")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_restaurar(idRol: int):
    """Llama al procedimiento almacenado sp_restaurar_rol(IN p_idRol)."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_restaurar_rol", [idRol])
        cnx.commit()
        print(f"✅ Rol ID {idRol} restaurado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_restaurar:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


# ---------------- MENÚ PRINCIPAL ----------------
def menu():
    """Muestra un menú interactivo en consola para gestionar los roles."""
    while True:
        print("\n===== MENÚ ROLES (MySQL + SP) =====")
        print("1) Insertar rol")
        print("2) Listar roles ACTIVOS")
        print("3) Listar roles (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar rol por ID")
        print("0) Salir")

        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            nombre = input("Nombre del rol: ").strip()
            if nombre:
                sp_insertar(nombre)
            else:
                print("❌ Nombre vacío.")
        elif opcion == "2":
            sp_listar_activos()
        elif opcion == "3":
            sp_listar_todos()
        elif opcion == "4":
            try:
                idr = int(input("ID del rol a eliminar: ").strip())
                sp_borrado_logico(idr)
            except ValueError:
                print("❌ ID inválido.")
        elif opcion == "5":
            try:
                idr = int(input("ID del rol a restaurar: ").strip())
                sp_restaurar(idr)
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

