#!/usr/bin/env python3
"""
Script para inicializar la base de datos con datos de prueba
"""
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from models import usuario, documento, tareas, permiso, entrega_comida
from auth import get_password_hash
from datetime import date, datetime

def init_db():
    """Inicializar la base de datos con datos de prueba"""
    db = SessionLocal()
    
    try:
        # Verificar si ya existen usuarios
        existing_users = db.query(usuario.Usuario).count()
        if existing_users > 0:
            print("La base de datos ya contiene datos. Saltando inicialización.")
            return
        
        print("Inicializando base de datos con datos de prueba...")
        
        # Crear usuarios de prueba
        users_data = [
            {
                "user_num_ident": "1007890123",
                "user_name": "Pedro",
                "user_ape": "Suárez Jiménez",
                "user_email": "pedro.suarez@sena.edu.co",
                "user_tel": "3127890123",
                "user_pass": get_password_hash("admin123"),
                "user_rol": "Administrador",
                "user_discap": "Ninguna",
                "etp_form_Apr": "Lectiva",
                "user_gen": "Masculino",
                "user_etn": "No Aplica",
                "user_img": "admin.jpg",
                "fec_ini_form_Apr": date(2023, 1, 1),
                "fec_fin_form_Apr": date(2023, 12, 31),
                "ficha_Apr": 0
            },
            {
                "user_num_ident": "1003456789",
                "user_name": "Juan",
                "user_ape": "Martínez García",
                "user_email": "juan.martinez@sena.edu.co",
                "user_tel": "3203456789",
                "user_pass": get_password_hash("delegado1"),
                "user_rol": "Delegado",
                "user_discap": "Ninguna",
                "etp_form_Apr": "Lectiva",
                "user_gen": "Masculino",
                "user_etn": "Indigina",
                "user_img": "delegado1.jpg",
                "fec_ini_form_Apr": date(2023, 1, 16),
                "fec_fin_form_Apr": date(2023, 12, 15),
                "ficha_Apr": 123456
            },
            {
                "user_num_ident": "1009012345",
                "user_name": "Andrés",
                "user_ape": "Vargas Rojas",
                "user_email": "andres.vargas@sena.edu.co",
                "user_tel": "3189012345",
                "user_pass": get_password_hash("delegado2"),
                "user_rol": "Delegado",
                "user_discap": "Ninguna",
                "etp_form_Apr": "Lectiva",
                "user_gen": "Masculino",
                "user_etn": "No Aplica",
                "user_img": "delegado2.jpg",
                "fec_ini_form_Apr": date(2023, 1, 16),
                "fec_fin_form_Apr": date(2023, 12, 15),
                "ficha_Apr": 123456
            },
            {
                "user_num_ident": "1001234567",
                "user_name": "Carlos",
                "user_ape": "Gómez Pérez",
                "user_email": "carlos.gomez@sena.edu.co",
                "user_tel": "3101234567",
                "user_pass": get_password_hash("aprendiz1"),
                "user_rol": "Aprendiz",
                "user_discap": "Ninguna",
                "etp_form_Apr": "Lectiva",
                "user_gen": "Masculino",
                "user_etn": "No Aplica",
                "user_img": "aprendiz1.jpg",
                "fec_ini_form_Apr": date(2023, 1, 16),
                "fec_fin_form_Apr": date(2023, 12, 15),
                "ficha_Apr": 123456
            },
            {
                "user_num_ident": "1002345678",
                "user_name": "María",
                "user_ape": "Rodríguez López",
                "user_email": "maria.rodriguez@sena.edu.co",
                "user_tel": "3152345678",
                "user_pass": get_password_hash("aprendiz2"),
                "user_rol": "Aprendiz",
                "user_discap": "Visual",
                "etp_form_Apr": "Productiva",
                "user_gen": "Femenino",
                "user_etn": "Afrodescendiente",
                "user_img": "aprendiz2.jpg",
                "fec_ini_form_Apr": date(2023, 2, 1),
                "fec_fin_form_Apr": date(2023, 11, 30),
                "ficha_Apr": 234567
            }
        ]
        
        # Crear usuarios
        created_users = []
        for user_data in users_data:
            db_user = usuario.Usuario(**user_data)
            db.add(db_user)
            created_users.append(db_user)
        
        db.commit()
        
        # Refrescar usuarios para obtener IDs
        for user in created_users:
            db.refresh(user)
        
        print(f"Se crearon {len(created_users)} usuarios")
        
        # Crear documentos de prueba
        admin_user = db.query(usuario.Usuario).filter(usuario.Usuario.user_rol == "Administrador").first()
        
        documentos_data = [
            {
                "doc_nombre": "Reglamento Interno",
                "doc_archivo": "reglamento.pdf",
                "doc_admin_id": admin_user.user_id
            },
            {
                "doc_nombre": "Manual de Convivencia",
                "doc_archivo": "convivencia.pdf",
                "doc_admin_id": admin_user.user_id
            },
            {
                "doc_nombre": "Calendario Académico 2023",
                "doc_archivo": "calendario.pdf",
                "doc_admin_id": admin_user.user_id
            }
        ]
        
        for doc_data in documentos_data:
            db_doc = documento.Documento(**doc_data)
            db.add(db_doc)
        
        db.commit()
        print("Se crearon 3 documentos de prueba")
        
        # Crear tareas de prueba
        aprendiz_user = db.query(usuario.Usuario).filter(usuario.Usuario.user_rol == "Aprendiz").first()
        
        tareas_data = [
            {
                "tarea_descripcion": "Limpiar el aula de sistemas",
                "tarea_fec_entrega": date(2023, 6, 15),
                "tarea_estado": "Completada",
                "tarea_admin_id": admin_user.user_id,
                "tarea_aprendiz_id": aprendiz_user.user_id
            },
            {
                "tarea_descripcion": "Organizar materiales de taller",
                "tarea_fec_entrega": date(2023, 6, 20),
                "tarea_estado": "En Proceso",
                "tarea_admin_id": admin_user.user_id,
                "tarea_aprendiz_id": aprendiz_user.user_id
            }
        ]
        
        for tarea_data in tareas_data:
            db_tarea = tareas.Tareas(**tarea_data)
            db.add(db_tarea)
        
        db.commit()
        print("Se crearon 2 tareas de prueba")
        
        # Crear permisos de prueba
        permisos_data = [
            {
                "permiso_motivo": "Consulta médica",
                "permiso_evidencia": "medico.pdf",
                "permiso_admin_id": admin_user.user_id,
                "permiso_aprendiz_id": aprendiz_user.user_id
            },
            {
                "permiso_motivo": "Problemas familiares",
                "permiso_evidencia": None,
                "permiso_admin_id": admin_user.user_id,
                "permiso_aprendiz_id": aprendiz_user.user_id
            }
        ]
        
        for permiso_data in permisos_data:
            db_permiso = permiso.Permiso(**permiso_data)
            db.add(db_permiso)
        
        db.commit()
        print("Se crearon 2 permisos de prueba")
        
        # Crear entregas de comida de prueba
        delegado_user = db.query(usuario.Usuario).filter(usuario.Usuario.user_rol == "Delegado").first()
        
        entregas_data = [
            {
                "entcom_comida": "Desayuno",
                "entcom_delegado_id": delegado_user.user_id,
                "entcom_aprendiz_id": aprendiz_user.user_id
            },
            {
                "entcom_comida": "Almuerzo",
                "entcom_delegado_id": delegado_user.user_id,
                "entcom_aprendiz_id": aprendiz_user.user_id
            }
        ]
        
        for entrega_data in entregas_data:
            db_entrega = entrega_comida.EntregaComida(**entrega_data)
            db.add(db_entrega)
        
        db.commit()
        print("Se crearon 2 entregas de comida de prueba")
        
        print("¡Base de datos inicializada exitosamente!")
        print("\nCredenciales de prueba:")
        print("Administrador: pedro.suarez@sena.edu.co / admin123")
        print("Delegado: juan.martinez@sena.edu.co / delegado1")
        print("Aprendiz: carlos.gomez@sena.edu.co / aprendiz1")
        
    except Exception as e:
        print(f"Error al inicializar la base de datos: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init_db()
