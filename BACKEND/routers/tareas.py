from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from typing import List
import os
import shutil
from datetime import datetime
from database import get_db
from auth import get_current_active_user, require_admin, require_delegado
from models.tareas import Tareas
from models.usuario import Usuario
from schemas.tareas import TareasCreate, TareasUpdate, TareasResponse

router = APIRouter(prefix="/tareas", tags=["Tareas"])

# Configurar directorio para evidencias
UPLOAD_DIR = "uploads/evidencias"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.get("/", response_model=List[TareasResponse])
async def get_tareas(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener lista de tareas"""
    if current_user.user_rol == "Aprendiz":
        # Los aprendices solo ven sus propias tareas
        tareas = db.query(Tareas).filter(Tareas.tarea_aprendiz_id == current_user.user_id).offset(skip).limit(limit).all()
    elif current_user.user_rol == "Delegado":
        # Los delegados ven todas las tareas
        tareas = db.query(Tareas).offset(skip).limit(limit).all()
    else:
        # Los administradores ven todas las tareas
        tareas = db.query(Tareas).offset(skip).limit(limit).all()
    
    return tareas

@router.get("/{tarea_id}", response_model=TareasResponse)
async def get_tarea(
    tarea_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener una tarea específica"""
    tarea = db.query(Tareas).filter(Tareas.tarea_id == tarea_id).first()
    if tarea is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tarea no encontrada"
        )
    
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and tarea.tarea_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para ver esta tarea"
        )
    
    return tarea

@router.post("/", response_model=TareasResponse)
async def create_tarea(
    tarea: TareasCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Crear una nueva tarea (solo administradores)"""
    # Verificar que el aprendiz existe
    aprendiz = db.query(Usuario).filter(Usuario.user_id == tarea.tarea_aprendiz_id).first()
    if not aprendiz or aprendiz.user_rol != "Aprendiz":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El aprendiz especificado no existe"
        )
    
    db_tarea = Tareas(
        tarea_descripcion=tarea.tarea_descripcion,
        tarea_fec_entrega=tarea.tarea_fec_entrega,
        tarea_estado=tarea.tarea_estado,
        tarea_admin_id=current_user.user_id,
        tarea_aprendiz_id=tarea.tarea_aprendiz_id
    )
    
    db.add(db_tarea)
    db.commit()
    db.refresh(db_tarea)
    
    return db_tarea

@router.put("/{tarea_id}", response_model=TareasResponse)
async def update_tarea(
    tarea_id: int,
    tarea: TareasUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Actualizar una tarea"""
    db_tarea = db.query(Tareas).filter(Tareas.tarea_id == tarea_id).first()
    if db_tarea is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tarea no encontrada"
        )
    
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and db_tarea.tarea_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para actualizar esta tarea"
        )
    
    # Actualizar solo los campos proporcionados
    update_data = tarea.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_tarea, field, value)
    
    # Si se marca como completada, establecer fecha de completado
    if update_data.get("tarea_estado") == "Completada" and not db_tarea.tarea_fec_completado:
        db_tarea.tarea_fec_completado = datetime.utcnow()
    
    db.commit()
    db.refresh(db_tarea)
    
    return db_tarea

@router.post("/{tarea_id}/evidencia")
async def upload_evidencia(
    tarea_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Subir evidencia para una tarea"""
    db_tarea = db.query(Tareas).filter(Tareas.tarea_id == tarea_id).first()
    if db_tarea is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tarea no encontrada"
        )
    
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and db_tarea.tarea_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para subir evidencia a esta tarea"
        )
    
    # Validar tipo de archivo
    allowed_extensions = {'.pdf', '.jpg', '.jpeg', '.png', '.doc', '.docx'}
    file_extension = os.path.splitext(file.filename)[1].lower()
    
    if file_extension not in allowed_extensions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Tipo de archivo no permitido"
        )
    
    # Generar nombre único para el archivo
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"evidencia_{tarea_id}_{timestamp}_{file.filename}"
    file_path = os.path.join(UPLOAD_DIR, filename)
    
    # Guardar archivo
    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al guardar el archivo: {str(e)}"
        )
    
    # Actualizar la tarea con la evidencia
    db_tarea.tarea_evidencia = filename
    db.commit()
    
    return {"message": "Evidencia subida exitosamente", "filename": filename}

@router.delete("/{tarea_id}")
async def delete_tarea(
    tarea_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Eliminar una tarea (solo administradores)"""
    db_tarea = db.query(Tareas).filter(Tareas.tarea_id == tarea_id).first()
    if db_tarea is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tarea no encontrada"
        )
    
    # Eliminar archivo de evidencia si existe
    if db_tarea.tarea_evidencia:
        file_path = os.path.join(UPLOAD_DIR, db_tarea.tarea_evidencia)
        if os.path.exists(file_path):
            os.remove(file_path)
    
    db.delete(db_tarea)
    db.commit()
    
    return {"message": "Tarea eliminada exitosamente"}

@router.get("/aprendiz/{aprendiz_id}", response_model=List[TareasResponse])
async def get_tareas_aprendiz(
    aprendiz_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener tareas de un aprendiz específico"""
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and current_user.user_id != aprendiz_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para ver las tareas de otro aprendiz"
        )
    
    tareas = db.query(Tareas).filter(Tareas.tarea_aprendiz_id == aprendiz_id).offset(skip).limit(limit).all()
    return tareas

@router.get("/estado/{estado}", response_model=List[TareasResponse])
async def get_tareas_por_estado(
    estado: str,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener tareas por estado"""
    if current_user.user_rol == "Aprendiz":
        tareas = db.query(Tareas).filter(
            Tareas.tarea_aprendiz_id == current_user.user_id,
            Tareas.tarea_estado == estado
        ).offset(skip).limit(limit).all()
    else:
        tareas = db.query(Tareas).filter(Tareas.tarea_estado == estado).offset(skip).limit(limit).all()
    
    return tareas
