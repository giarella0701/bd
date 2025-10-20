import mysql.connector

# ---------- CONFIGURACIÓN DE CONEXIÓN ----------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "contrasena",  # Reemplaza con tu contraseña
    "database": "empresa"
}

# ---------- FUNCIÓN DE CONEXIÓN ----------
def conectar():
    return mysql.connector.connect(**DB_CONFIG)

# ---------- FUNCIONES CRUD CON SP ----------

def sp_insertar_rol(nombre_rol: str) -> int:
    """Inserta un nuevo rol y devuelve su ID"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        args = [nombre_rol, 0]  # El segundo es OUT id generado
        args = cur.callproc("sp_insertar_rol", args)
        cnx.commit()
        nuevo_id = args[1]
        print(f"✅ Rol insertado correctamente. ID: {nuevo_id}")
        return nuevo_id
    except mysql.connector.Error as e:
        print("❌ Error en sp_insertar_rol:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
        return -1
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_listar_roles():
    """Lista todos los roles activos"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_listar_roles_activos")
        print("=== ROLES ACTIVOS ===")
        for result in cur.stored_results():
            for (idRol, nombre_rol, created_at, updated_at, deleted) in result.fetchall():
                estado = "ACTIVO" if deleted == 0 else "INACTIVO"
                ua = updated_at if updated_at is not None else "-"
                print(f"ID:{idRol:<3} | Rol:{nombre_rol:<20} | Estado:{estado:<8} | Creado:{created_at} | Actualizado:{ua}")
    except mysql.connector.Error as e:
        print("❌ Error en sp_listar_roles:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_borrado_logico_rol(idRol: int):
    """Marca un rol como eliminado (borrado lógico)"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_borrado_logico_rol", [idRol])
        cnx.commit()
        print(f"✅ Rol ID {idRol} marcado como inactivo.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_borrado_logico_rol:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def sp_restaurar_rol(idRol: int):
    """Restaura un rol eliminado lógicamente"""
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_restaurar_rol", [idRol])
        cnx.commit()
        print(f"✅ Rol ID {idRol} restaurado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error en sp_restaurar_rol:", e)
        if cnx and cnx.is_connected():
            try: cnx.rollback()
            except: pass
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

# ---------- MENÚ INTERACTIVO ----------
def menu_roles():
    while True:
        print("\n===== MENÚ ROLES (MySQL + SP) =====")
        print("1) Insertar rol")
        print("2) Listar roles activos")
        print("3) Borrado lógico por ID")
        print("4) Restaurar rol por ID")
        print("0) Salir")

        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            nombre = input("Nombre del rol: ").strip()
            sp_insertar_rol(nombre)
        elif opcion == "2":
            sp_listar_roles()
        elif opcion == "3":
            try:
                idRol = int(input("ID del rol a eliminar: ").strip())
            except ValueError:
                print("❌ ID inválido.")
                continue
            sp_borrado_logico_rol(idRol)
        elif opcion == "4":
            try:
                idRol = int(input("ID del rol a restaurar: ").strip())
            except ValueError:
                print("❌ ID inválido.")
                continue
            sp_restaurar_rol(idRol)
        elif opcion == "0":
            print("👋 Saliendo del sistema...")
            break
        else:
            print("❌ Opción no válida. Intenta nuevamente.")

# Punto de entrada
if __name__ == "__main__":
    menu_roles()

