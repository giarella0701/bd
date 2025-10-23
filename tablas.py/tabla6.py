import mysql.connector
from mysql.connector import Error

# --- Conexión ---
def conectar():
    try:
        conexion = mysql.connector.connect(
            host="localhost",
            user="root",
            password="1234",
            database="sistema_seguridad_vial"
        )
        if conexion.is_connected():
            print("✅ Conexión establecida con MySQL.")
            return conexion
    except Error as e:
        print(f"❌ Error de conexión: {e}")
        return None


# --- Insertar cambio ---
def sp_insertar_cambio():
    conexion = conectar()
    if not conexion:
        return

    try:
        usuario_id = int(input("Ingrese el ID del usuario: "))
        descripcion = input("Descripción del cambio: ")
        version = input("Versión afectada: ")
        fecha = input("Fecha del cambio (YYYY-MM-DD): ")

        cur = conexion.cursor()
        cur.callproc("sp_cambio_insertar", [usuario_id, descripcion, version, fecha])
        conexion.commit()
        print("✅ Cambio insertado correctamente.")

    except Error as e:
        print(f"❌ Error en sp_insertar_cambio: {e}")
    finally:
        cur.close()
        conexion.close()


# --- Listar cambios activos ---
def sp_listar_cambios_activos():
    conexion = conectar()
    if not conexion:
        return

    try:
        cur = conexion.cursor()
        cur.callproc("sp_cambio_listar_activos")

        print("\n📋 CAMBIOS ACTIVOS:")
        print("-" * 120)

        for result in cur.stored_results():
            filas = result.fetchall()

            for fila in filas:
                # Evita error de formato reemplazando None por cadena vacía
                fila = ["" if v is None else v for v in fila]

                cambio_id, usuario_id, descripcion, version, fecha_cambio, created_at, updated_at, deleted = fila

                print(f"ID:{cambio_id:<3} | Usuario:{usuario_id:<3} | Desc:{descripcion:<35} | Versión:{version:<12} | Fecha:{fecha_cambio:<12} | Creado:{created_at:<19} | Actualizado:{updated_at:<19}")

        print("-" * 120)

    except Error as e:
        print(f"❌ Error en sp_listar_cambios_activos: {e}")
    finally:
        cur.close()
        conexion.close()


# --- Borrado lógico ---
def sp_borrado_logico_cambio():
    conexion = conectar()
    if not conexion:
        return

    try:
        cambio_id = int(input("Ingrese el ID del cambio a eliminar: "))
        cur = conexion.cursor()
        cur.callproc("sp_cambio_borrado_logico", [cambio_id])
        conexion.commit()
        print("🗑️ Cambio marcado como eliminado correctamente.")
    except Error as e:
        print(f"❌ Error en sp_borrado_logico_cambio: {e}")
    finally:
        cur.close()
        conexion.close()


# --- Menú principal ---
def menu():
    while True:
        print("\n📋 MENÚ CAMBIO DE APLICACIÓN")
        print("1. Insertar nuevo cambio")
        print("2. Listar cambios activos")
        print("3. Eliminar cambio (borrado lógico)")
        print("4. Salir")

        opcion = input("Seleccione una opción: ")

        if opcion == "1":
            sp_insertar_cambio()
        elif opcion == "2":
            sp_listar_cambios_activos()
        elif opcion == "3":
            sp_borrado_logico_cambio()
        elif opcion == "4":
            print("👋 Saliendo del sistema...")
            break
        else:
            print("❌ Opción no válida, intente de nuevo.")


if __name__ == "__main__":
    menu()
