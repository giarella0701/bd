# ==========================================
# sp_menu_ruta.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Autor: Giarella
# Propósito: Gestionar rutas sin necesidad de ingresar IDs
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
def sp_insertar_ruta(nombre_ruta, comuna, coordenadas, estado, descripcion):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        args = [nombre_ruta, comuna, coordenadas, estado, descripcion]
        cur.callproc("sp_ruta_insertar", args)
        cnx.commit()
        print(f"✅ Ruta '{nombre_ruta}' insertada correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar_ruta:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_rutas_activos():
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("SELECT idRuta, nombre_ruta, comuna, coordenadas, estado, descripcion FROM Ruta WHERE deleted=0")
        print("=== RUTAS ACTIVAS ===")
        for (idRuta, nombre_ruta, comuna, coordenadas, estado, descripcion) in cur.fetchall():
            print(f"ID:{idRuta:<3} | Nombre:{nombre_ruta:<20} | Comuna:{comuna or '-':<15} | Estado:{estado:<15} | Descripción:{descripcion[:50]+'...' if descripcion else '-'}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_rutas_activos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_borrado_logico_ruta(idRuta):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("UPDATE Ruta SET deleted=1, updated_at=CURRENT_TIMESTAMP WHERE idRuta=%s", (idRuta,))
        cnx.commit()
        print(f"✅ Ruta ID {idRuta} eliminada lógicamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico_ruta:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------------- MENÚ PRINCIPAL ----------------
def menu():
    while True:
        print("\n===== MENÚ RUTAS (MySQL + SP) =====")
        print("1) Insertar ruta")
        print("2) Listar rutas ACTIVAS")
        print("3) Borrado lógico de ruta")
        print("0) Salir")
        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            nombre_ruta = input("Nombre de la ruta: ").strip()
            comuna = input("Comuna: ").strip()
            coordenadas = input("Coordenadas GPS: ").strip()
            estado = input("Estado (Operativo/En Mantenimiento/Cerrado/Restringido): ").strip() or "Operativo"
            descripcion = input("Descripción: ").strip()
            sp_insertar_ruta(nombre_ruta, comuna, coordenadas, estado, descripcion)
        elif opcion == "2":
            sp_listar_rutas_activos()
        elif opcion == "3":
            try:
                idRuta = int(input("ID de la ruta a eliminar: ").strip())
                sp_borrado_logico_ruta(idRuta)
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
