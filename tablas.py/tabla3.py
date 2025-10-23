# ==========================================
# sp_menu_accidente.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Autor: Giarella
# Propósito: Gestionar accidentes reportados (insertar, listar, actualizar estado, eliminar)
# utilizando procedimientos almacenados y el conector oficial de MySQL.
# ==========================================

import mysql.connector
from datetime import datetime

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
def sp_insertar_accidente(descripcion, severidad, ubicacion, tipo_accidente, fecha_accidente, Usuarios_idUsuarios):
    """Inserta un nuevo accidente usando el SP sp_accidente_insertar."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        args = [descripcion, severidad, ubicacion, tipo_accidente, fecha_accidente, Usuarios_idUsuarios]
        cur.callproc("sp_accidente_insertar", args)
        cnx.commit()
        print(f"✅ Accidente reportado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar_accidente:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_accidentes_activos():
    """Lista todos los accidentes activos con su reportero usando sp_accidente_listar_activos."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_accidente_listar_activos")
        print("=== ACCIDENTES ACTIVOS ===")
        for result in cur.stored_results():
            for (idAccidente, severidad, ubicacion, tipo_accidente, fecha_accidente, estado, reportado_por) in result.fetchall():
                tipo_acc = tipo_accidente if tipo_accidente else "-"
                print(f"ID:{idAccidente:<3} | Severidad:{severidad:<10} | Tipo:{tipo_acc:<12} | "
                    f"Ubicación:{ubicacion:<25} | Fecha:{fecha_accidente} | Estado:{estado:<12} | Reportado por:{reportado_por}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_accidentes_activos:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_actualizar_estado_accidente(idAccidente, nuevo_estado):
    """Actualiza el estado de un accidente usando sp_accidente_actualizar_estado."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_accidente_actualizar_estado", [idAccidente, nuevo_estado])
        cnx.commit()
        print(f"✅ Accidente ID {idAccidente} actualizado a estado '{nuevo_estado}'.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_actualizar_estado_accidente:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_borrado_logico_accidente(idAccidente):
    """Aplica borrado lógico a un accidente usando sp_accidente_borrado_logico."""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_accidente_borrado_logico", [idAccidente])
        cnx.commit()
        print(f"✅ Accidente ID {idAccidente} marcado como eliminado (borrado lógico).")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico_accidente:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------------- MENÚ PRINCIPAL ----------------
def menu():
    """Menú interactivo para gestionar accidentes."""
    while True:
        print("\n===== MENÚ ACCIDENTES (MySQL + SP) =====")
        print("1) Reportar nuevo accidente")
        print("2) Listar accidentes ACTIVOS")
        print("3) Actualizar estado de accidente")
        print("4) Borrado lógico por ID")
        print("0) Salir")
        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            descripcion = input("Descripción: ").strip()
            severidad = input("Severidad (Leve, Moderado, Grave, Fatal): ").strip()
            ubicacion = input("Ubicación: ").strip()
            tipo_accidente = input("Tipo de accidente (opcional): ").strip() or None
            fecha_input = input("Fecha y hora (YYYY-MM-DD HH:MM:SS): ").strip()
            try:
                fecha_accidente = datetime.strptime(fecha_input, "%Y-%m-%d %H:%M:%S")
            except ValueError:
                print("❌ Formato de fecha inválido.")
                continue
            try:
                Usuarios_idUsuarios = int(input("ID del usuario que reporta: ").strip())
            except ValueError:
                print("❌ ID de usuario inválido.")
                continue
            sp_insertar_accidente(descripcion, severidad, ubicacion, tipo_accidente, fecha_accidente, Usuarios_idUsuarios)

        elif opcion == "2":
            sp_listar_accidentes_activos()

        elif opcion == "3":
            try:
                idAcc = int(input("ID del accidente a actualizar: ").strip())
                nuevo_estado = input("Nuevo estado (Reportado, En Revisión, Cerrado, Archivado): ").strip()
                sp_actualizar_estado_accidente(idAcc, nuevo_estado)
            except ValueError:
                print("❌ ID inválido.")

        elif opcion == "4":
            try:
                idAcc = int(input("ID del accidente a eliminar: ").strip())
                sp_borrado_logico_accidente(idAcc)
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
