from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime, date
from database import get_db
from auth import get_current_active_user, require_delegado
from models.entrega_comida import EntregaComida
from models.usuario import Usuario
from schemas.entrega_comida import EntregaComidaCreate, EntregaComidaUpdate, EntregaComidaResponse

router = APIRouter(prefix="/entregas-comida", tags=["Entregas de Comida"])

@router.get("/", response_model=List[EntregaComidaResponse])
async def get_entregas_comida(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener lista de entregas de comida"""
    if current_user.user_rol == "Aprendiz":
        # Los aprendices solo ven sus propias entregas
        entregas = db.query(EntregaComida).filter(
            EntregaComida.entcom_aprendiz_id == current_user.user_id
        ).offset(skip).limit(limit).all()
    else:
        # Delegados y administradores ven todas las entregas
        entregas = db.query(EntregaComida).offset(skip).limit(limit).all()
    
    return entregas

@router.get("/{entcom_id}", response_model=EntregaComidaResponse)
async def get_entrega_comida(
    entcom_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener una entrega de comida específica"""
    entrega = db.query(EntregaComida).filter(EntregaComida.entcom_id == entcom_id).first()
    if entrega is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Entrega de comida no encontrada"
        )
    
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and entrega.entcom_aprendiz_id != current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para ver esta entrega"
        )
    
    return entrega

@router.post("/", response_model=EntregaComidaResponse)
async def create_entrega_comida(
    entrega: EntregaComidaCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_delegado)
):
    """Crear una nueva entrega de comida (solo delegados y administradores)"""
    # Verificar que el delegado existe
    delegado = db.query(Usuario).filter(Usuario.user_id == entrega.entcom_delegado_id).first()
    if not delegado or delegado.user_rol not in ["Delegado", "Administrador"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El delegado especificado no existe o no tiene permisos"
        )
    
    # Verificar que el aprendiz existe
    aprendiz = db.query(Usuario).filter(Usuario.user_id == entrega.entcom_aprendiz_id).first()
    if not aprendiz or aprendiz.user_rol != "Aprendiz":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El aprendiz especificado no existe"
        )
    
    # Solo el delegado asignado puede crear la entrega
    if current_user.user_id != entrega.entcom_delegado_id and current_user.user_rol != "Administrador":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo puedes crear entregas como delegado asignado"
        )
    
    db_entrega = EntregaComida(
        entcom_comida=entrega.entcom_comida,
        entcom_delegado_id=entrega.entcom_delegado_id,
        entcom_aprendiz_id=entrega.entcom_aprendiz_id
    )
    
    db.add(db_entrega)
    db.commit()
    db.refresh(db_entrega)
    
    return db_entrega

@router.put("/{entcom_id}", response_model=EntregaComidaResponse)
async def update_entrega_comida(
    entcom_id: int,
    entrega: EntregaComidaUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_delegado)
):
    """Actualizar una entrega de comida"""
    db_entrega = db.query(EntregaComida).filter(EntregaComida.entcom_id == entcom_id).first()
    if db_entrega is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Entrega de comida no encontrada"
        )
    
    # Verificar permisos
    if current_user.user_id != db_entrega.entcom_delegado_id and current_user.user_rol != "Administrador":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para actualizar esta entrega"
        )
    
    # Actualizar solo los campos proporcionados
    update_data = entrega.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_entrega, field, value)
    
    db.commit()
    db.refresh(db_entrega)
    
    return db_entrega

@router.delete("/{entcom_id}")
async def delete_entrega_comida(
    entcom_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_delegado)
):
    """Eliminar una entrega de comida"""
    db_entrega = db.query(EntregaComida).filter(EntregaComida.entcom_id == entcom_id).first()
    if db_entrega is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Entrega de comida no encontrada"
        )
    
    # Verificar permisos
    if current_user.user_id != db_entrega.entcom_delegado_id and current_user.user_rol != "Administrador":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para eliminar esta entrega"
        )
    
    db.delete(db_entrega)
    db.commit()
    
    return {"message": "Entrega de comida eliminada exitosamente"}

@router.get("/aprendiz/{aprendiz_id}", response_model=List[EntregaComidaResponse])
async def get_entregas_aprendiz(
    aprendiz_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener entregas de comida de un aprendiz específico"""
    # Verificar permisos
    if current_user.user_rol == "Aprendiz" and current_user.user_id != aprendiz_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para ver las entregas de otro aprendiz"
        )
    
    entregas = db.query(EntregaComida).filter(
        EntregaComida.entcom_aprendiz_id == aprendiz_id
    ).offset(skip).limit(limit).all()
    
    return entregas

@router.get("/delegado/{delegado_id}", response_model=List[EntregaComidaResponse])
async def get_entregas_delegado(
    delegado_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener entregas de comida realizadas por un delegado específico"""
    # Verificar permisos
    if current_user.user_rol == "Aprendiz":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Los aprendices no pueden ver entregas por delegado"
        )
    
    entregas = db.query(EntregaComida).filter(
        EntregaComida.entcom_delegado_id == delegado_id
    ).offset(skip).limit(limit).all()
    
    return entregas

@router.get("/fecha/{fecha}", response_model=List[EntregaComidaResponse])
async def get_entregas_por_fecha(
    fecha: date,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener entregas de comida por fecha"""
    if current_user.user_rol == "Aprendiz":
        # Los aprendices solo ven sus entregas de la fecha especificada
        entregas = db.query(EntregaComida).filter(
            EntregaComida.entcom_aprendiz_id == current_user.user_id,
            EntregaComida.entcom_fec_entrega.cast(date) == fecha
        ).offset(skip).limit(limit).all()
    else:
        # Delegados y administradores ven todas las entregas de la fecha
        entregas = db.query(EntregaComida).filter(
            EntregaComida.entcom_fec_entrega.cast(date) == fecha
        ).offset(skip).limit(limit).all()
    
    return entregas

@router.get("/tipo/{tipo_comida}", response_model=List[EntregaComidaResponse])
async def get_entregas_por_tipo(
    tipo_comida: str,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener entregas de comida por tipo (Desayuno, Almuerzo, Cena)"""
    if current_user.user_rol == "Aprendiz":
        # Los aprendices solo ven sus entregas del tipo especificado
        entregas = db.query(EntregaComida).filter(
            EntregaComida.entcom_aprendiz_id == current_user.user_id,
            EntregaComida.entcom_comida == tipo_comida
        ).offset(skip).limit(limit).all()
    else:
        # Delegados y administradores ven todas las entregas del tipo
        entregas = db.query(EntregaComida).filter(
            EntregaComida.entcom_comida == tipo_comida
        ).offset(skip).limit(limit).all()
    
    return entregas

@router.get("/hoy/", response_model=List[EntregaComidaResponse])
async def get_entregas_hoy(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener entregas de comida de hoy"""
    hoy = date.today()
    
    if current_user.user_rol == "Aprendiz":
        # Los aprendices solo ven sus entregas de hoy
        entregas = db.query(EntregaComida).filter(
            EntregaComida.entcom_aprendiz_id == current_user.user_id,
            EntregaComida.entcom_fec_entrega.cast(date) == hoy
        ).offset(skip).limit(limit).all()
    else:
        # Delegados y administradores ven todas las entregas de hoy
        entregas = db.query(EntregaComida).filter(
            EntregaComida.entcom_fec_entrega.cast(date) == hoy
        ).offset(skip).limit(limit).all()
    
    return entregas
