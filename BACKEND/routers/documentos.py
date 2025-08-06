from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from typing import List
import os
import shutil
from datetime import datetime
from database import get_db
from auth import get_current_active_user, require_admin
from models.documento import Documento
from models.usuario import Usuario
from schemas.documento import DocumentoCreate, DocumentoUpdate, DocumentoResponse

router = APIRouter(prefix="/documentos", tags=["Documentos"])

# Configurar directorio para archivos
UPLOAD_DIR = "uploads/documentos"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.get("/", response_model=List[DocumentoResponse])
async def get_documentos(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener lista de documentos"""
    documentos = db.query(Documento).offset(skip).limit(limit).all()
    return documentos

@router.get("/{doc_id}", response_model=DocumentoResponse)
async def get_documento(
    doc_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener un documento específico"""
    documento = db.query(Documento).filter(Documento.doc_id == doc_id).first()
    if documento is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Documento no encontrado"
        )
    return documento

@router.post("/", response_model=DocumentoResponse)
async def create_documento(
    doc_nombre: str,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Crear un nuevo documento (solo administradores)"""
    # Validar tipo de archivo
    allowed_extensions = {'.pdf', '.doc', '.docx', '.txt', '.jpg', '.jpeg', '.png'}
    file_extension = os.path.splitext(file.filename)[1].lower()
    
    if file_extension not in allowed_extensions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Tipo de archivo no permitido"
        )
    
    # Generar nombre único para el archivo
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"{timestamp}_{file.filename}"
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
    
    # Crear registro en la base de datos
    db_documento = Documento(
        doc_nombre=doc_nombre,
        doc_archivo=filename,
        doc_admin_id=current_user.user_id
    )
    
    db.add(db_documento)
    db.commit()
    db.refresh(db_documento)
    
    return db_documento

@router.put("/{doc_id}", response_model=DocumentoResponse)
async def update_documento(
    doc_id: int,
    documento: DocumentoUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Actualizar un documento (solo administradores)"""
    db_documento = db.query(Documento).filter(Documento.doc_id == doc_id).first()
    if db_documento is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Documento no encontrado"
        )
    
    # Actualizar solo los campos proporcionados
    update_data = documento.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_documento, field, value)
    
    db.commit()
    db.refresh(db_documento)
    
    return db_documento

@router.delete("/{doc_id}")
async def delete_documento(
    doc_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Eliminar un documento (solo administradores)"""
    db_documento = db.query(Documento).filter(Documento.doc_id == doc_id).first()
    if db_documento is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Documento no encontrado"
        )
    
    # Eliminar archivo físico
    file_path = os.path.join(UPLOAD_DIR, db_documento.doc_archivo)
    if os.path.exists(file_path):
        os.remove(file_path)
    
    # Eliminar registro de la base de datos
    db.delete(db_documento)
    db.commit()
    
    return {"message": "Documento eliminado exitosamente"}

@router.get("/download/{doc_id}")
async def download_documento(
    doc_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Descargar un documento"""
    documento = db.query(Documento).filter(Documento.doc_id == doc_id).first()
    if documento is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Documento no encontrado"
        )
    
    file_path = os.path.join(UPLOAD_DIR, documento.doc_archivo)
    if not os.path.exists(file_path):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Archivo no encontrado en el servidor"
        )
    
    return {"file_path": file_path, "filename": documento.doc_archivo}
