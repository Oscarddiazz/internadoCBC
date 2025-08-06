from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from typing import List
import os
import shutil
from datetime import datetime
from database import get_db
from auth import get_current_active_user, require_admin
from models.permiso import Permiso
from models.usuario import Usuario
from schemas.permiso import PermisoCreate, PermisoUpdate, PermisoResponse

router = APIRouter(prefix="/permisos", tags=["Permisos"])

# Configurar directorio para evidencias de permisos
UPLOAD_DIR = "uploads/permisos"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.get("/", response_model=List[PermisoResponse])
async def get_permisos(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener lista de permisos"""
    if current_user.user_rol == "Aprendiz":
        # Los aprendices solo ven sus propios permisos
        permisos = db.query(Permiso).filter(Permiso.permiso_aprendiz_id == current_user.user_id).offset(skip).limit(limit).all()
    else:
        # Administradores y delegados ven todos los permisos
        permisos = db.query(Permiso).offset(skip).limit(limit).all()
    
    return permisos

@router.get("/{permiso_id}", response_model=PermisoResponse)
async def get_permiso(
    permiso_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener un permiso específico"""
    permiso = db.query(Permiso).filter(Permiso.permiso_id == permiso_id).first()
    if permiso is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Permiso no encontrado"
        )
    
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and permiso.permiso_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para ver este permiso"
        )
    
    return permiso

@router.post("/", response_model=PermisoResponse)
async def create_permiso(
    permiso: PermisoCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Crear una nueva solicitud de permiso"""
    # Verificar que el aprendiz existe
    aprendiz = db.query(Usuario).filter(Usuario.user_id == permiso.permiso_aprendiz_id).first()
    if not aprendiz or aprendiz.user_rol != "Aprendiz":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El aprendiz especificado no existe"
        )
    
    # Verificar que el administrador existe
    admin = db.query(Usuario).filter(Usuario.user_id == permiso.permiso_admin_id).first()
    if not admin or admin.user_rol != "Administrador":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El administrador especificado no existe"
        )
    
    # Los aprendices solo pueden crear permisos para sí mismos
    if current_user.user_rol == "Aprendiz" and permiso.permiso_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo puedes crear permisos para ti mismo"
        )
    
    db_permiso = Permiso(
        permiso_motivo=permiso.permiso_motivo,
        permiso_evidencia=permiso.permiso_evidencia,
        permiso_admin_id=permiso.permiso_admin_id,
        permiso_aprendiz_id=permiso.permiso_aprendiz_id
    )
    
    db.add(db_permiso)
    db.commit()
    db.refresh(db_permiso)
    
    return db_permiso

@router.put("/{permiso_id}", response_model=PermisoResponse)
async def update_permiso(
    permiso_id: int,
    permiso: PermisoUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Actualizar un permiso"""
    db_permiso = db.query(Permiso).filter(Permiso.permiso_id == permiso_id).first()
    if db_permiso is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Permiso no encontrado"
        )
    
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and db_permiso.permiso_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para actualizar este permiso"
        )
    
    # Solo administradores pueden responder permisos
    if "permiso_fec_res" in permiso.dict(exclude_unset=True) and current_user.user_rol != "Administrador":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo los administradores pueden responder permisos"
        )
    
    # Actualizar solo los campos proporcionados
    update_data = permiso.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_permiso, field, value)
    
    # Si se está respondiendo, establecer fecha de respuesta
    if "permiso_fec_res" in update_data and not db_permiso.permiso_fec_res:
        db_permiso.permiso_fec_res = datetime.utcnow()
    
    db.commit()
    db.refresh(db_permiso)
    
    return db_permiso

@router.post("/{permiso_id}/evidencia")
async def upload_evidencia_permiso(
    permiso_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Subir evidencia para un permiso"""
    db_permiso = db.query(Permiso).filter(Permiso.permiso_id == permiso_id).first()
    if db_permiso is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Permiso no encontrado"
        )
    
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and db_permiso.permiso_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para subir evidencia a este permiso"
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
    filename = f"permiso_{permiso_id}_{timestamp}_{file.filename}"
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
    
    # Actualizar el permiso con la evidencia
    db_permiso.permiso_evidencia = filename
    db.commit()
    
    return {"message": "Evidencia subida exitosamente", "filename": filename}

@router.delete("/{permiso_id}")
async def delete_permiso(
    permiso_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Eliminar un permiso (solo administradores)"""
    db_permiso = db.query(Permiso).filter(Permiso.permiso_id == permiso_id).first()
    if db_permiso is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Permiso no encontrado"
        )
    
    # Eliminar archivo de evidencia si existe
    if db_permiso.permiso_evidencia:
        file_path = os.path.join(UPLOAD_DIR, db_permiso.permiso_evidencia)
        if os.path.exists(file_path):
            os.remove(file_path)
    
    db.delete(db_permiso)
    db.commit()
    
    return {"message": "Permiso eliminado exitosamente"}

@router.get("/aprendiz/{aprendiz_id}", response_model=List[PermisoResponse])
async def get_permisos_aprendiz(
    aprendiz_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener permisos de un aprendiz específico"""
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and current_user.user_id != aprendiz_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para ver los permisos de otro aprendiz"
        )
    
    permisos = db.query(Permiso).filter(Permiso.permiso_aprendiz_id == aprendiz_id).offset(skip).limit(limit).all()
    return permisos

@router.get("/pendientes/", response_model=List[PermisoResponse])
async def get_permisos_pendientes(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener permisos pendientes de respuesta"""
    if current_user.user_rol == "Aprendiz":
        permisos = db.query(Permiso).filter(
            Permiso.permiso_aprendiz_id == current_user.user_id,
            Permiso.permiso_fec_res.is_(None)
        ).offset(skip).limit(limit).all()
    else:
        permisos = db.query(Permiso).filter(Permiso.permiso_fec_res.is_(None)).offset(skip).limit(limit).all()
    
    return permisos
