# ==========================================
# sp_menu_leyes.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Autor: Giarella
# Propósito: Gestionar Leyes y Normas (insertar, listar y borrado lógico)
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
def sp_insertar_ley(titulo: str, categoria: str, fecha_publicacion: str):
    """
    Inserta una nueva Ley/Norma usando el procedimiento almacenado:
    sp_leyes_normas_insertar(IN p_titulo, IN p_categoria, IN p_fecha_publicacion)
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_leyes_normas_insertar", [titulo, categoria, fecha_publicacion])
        cnx.commit()
        print(f"✅ Ley/Norma '{titulo}' insertada correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar_ley:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_listar_leyes_activos():
    """
    Lista todas las Leyes/Normas activas usando el procedimiento almacenado:
    sp_leyes_normas_listar_activos()
    """
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_leyes_normas_listar_activos")

        print("=== LEYES Y NORMAS ACTIVAS ===")
        for result in cur.stored_results():  # nota: stored_results() funciona pero es la versión actual
            rows = result.fetchall()
            if not rows:
                print("No hay registros activos.")
            else:
                for (id_Ley, titulo, categoria, fecha_publicacion) in rows:
                    print(f"ID:{id_Ley:<3} | Título:{titulo:<35} | Categoría:{categoria:<15} | Publicación:{fecha_publicacion}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_leyes_activos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


def sp_borrado_logico_ley(id_Ley: int):
    """Borra lógicamente una Ley/Norma usando sp_leyes_normas_borrado_logico(IN p_id_Ley)."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_leyes_normas_borrado_logico", [id_Ley])
        cnx.commit()
        print(f"✅ Ley/Norma ID {id_Ley} marcada como eliminada (borrado lógico).")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico_ley:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------------- MENÚ PRINCIPAL ----------------
def menu():
    """Muestra un menú interactivo en consola para gestionar Leyes y Normas."""
    while True:
        print("|-----------------------------------------------|")
        print("|         MENÚ LEYES Y NORMAS (MySQL + SP)     |")
        print("|-----------------------------------------------|")
        print("| 1) Insertar Ley/Norma                         |")
        print("| 2) Listar Leyes/Normas ACTIVAS               |")
        print("| 3) Borrado lógico por ID                      |")
        print("| 0) Salir                                     |")
        print("|-----------------------------------------------|")
        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            titulo = input("Título de la Ley/Norma: ").strip()
            categoria = input("Categoría: ").strip()
            fecha_publicacion = input("Fecha de publicación (YYYY-MM-DD): ").strip()
            if titulo and fecha_publicacion:
                sp_insertar_ley(titulo, categoria, fecha_publicacion)
            else:
                print("❌ Título o fecha vacíos.")
        elif opcion == "2":
            sp_listar_leyes_activos()
        elif opcion == "3":
            try:
                id_ley = int(input("ID de la Ley/Norma a eliminar: ").strip())
                sp_borrado_logico_ley(id_ley)
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
