from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from database import get_db
from auth import get_current_active_user, require_admin, get_password_hash
from models.usuario import Usuario
from schemas.usuario import UsuarioCreate, UsuarioUpdate, UsuarioResponse

router = APIRouter(prefix="/usuarios", tags=["Usuarios"])

@router.get("/", response_model=List[UsuarioResponse])
async def get_usuarios(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Obtener lista de usuarios (solo administradores)"""
    usuarios = db.query(Usuario).offset(skip).limit(limit).all()
    return usuarios

@router.get("/me", response_model=UsuarioResponse)
async def get_current_user_info(
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener información del usuario actual"""
    return current_user

@router.get("/{user_id}", response_model=UsuarioResponse)
async def get_usuario(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener un usuario específico"""
    # Solo administradores pueden ver otros usuarios, o el propio usuario
    if current_user.user_rol != "Administrador" and current_user.user_id != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para ver este usuario"
        )
    
    usuario = db.query(Usuario).filter(Usuario.user_id == user_id).first()
    if usuario is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado"
        )
    return usuario

@router.post("/", response_model=UsuarioResponse)
async def create_usuario(
    usuario: UsuarioCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Crear un nuevo usuario (solo administradores)"""
    # Verificar si el email ya existe
    db_user = db.query(Usuario).filter(Usuario.user_email == usuario.user_email).first()
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El email ya está registrado"
        )
    
    # Verificar si el número de identificación ya existe
    db_user = db.query(Usuario).filter(Usuario.user_num_ident == usuario.user_num_ident).first()
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El número de identificación ya está registrado"
        )
    
    # Crear el nuevo usuario
    hashed_password = get_password_hash(usuario.user_pass)
    db_user = Usuario(
        user_num_ident=usuario.user_num_ident,
        user_name=usuario.user_name,
        user_ape=usuario.user_ape,
        user_email=usuario.user_email,
        user_tel=usuario.user_tel,
        user_pass=hashed_password,
        user_rol=usuario.user_rol,
        user_discap=usuario.user_discap,
        etp_form_Apr=usuario.etp_form_Apr,
        user_gen=usuario.user_gen,
        user_etn=usuario.user_etn,
        user_img=usuario.user_img,
        fec_ini_form_Apr=usuario.fec_ini_form_Apr,
        fec_fin_form_Apr=usuario.fec_fin_form_Apr,
        ficha_Apr=usuario.ficha_Apr
    )
    
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return db_user

@router.put("/{user_id}", response_model=UsuarioResponse)
async def update_usuario(
    user_id: int,
    usuario: UsuarioUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Actualizar un usuario"""
    # Solo administradores pueden actualizar otros usuarios, o el propio usuario
    if current_user.user_rol != "Administrador" and current_user.user_id != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permisos para actualizar este usuario"
        )
    
    db_user = db.query(Usuario).filter(Usuario.user_id == user_id).first()
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado"
        )
    
    # Actualizar solo los campos proporcionados
    update_data = usuario.dict(exclude_unset=True)
    
    # Si se está actualizando la contraseña, hashearla
    if "user_pass" in update_data:
        update_data["user_pass"] = get_password_hash(update_data["user_pass"])
    
    for field, value in update_data.items():
        setattr(db_user, field, value)
    
    db.commit()
    db.refresh(db_user)
    
    return db_user

@router.delete("/{user_id}")
async def delete_usuario(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(require_admin)
):
    """Eliminar un usuario (solo administradores)"""
    db_user = db.query(Usuario).filter(Usuario.user_id == user_id).first()
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado"
        )
    
    db.delete(db_user)
    db.commit()
    
    return {"message": "Usuario eliminado exitosamente"}

@router.get("/aprendices/", response_model=List[UsuarioResponse])
async def get_aprendices(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener lista de aprendices"""
    aprendices = db.query(Usuario).filter(Usuario.user_rol == "Aprendiz").offset(skip).limit(limit).all()
    return aprendices

@router.get("/delegados/", response_model=List[UsuarioResponse])
async def get_delegados(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_active_user)
):
    """Obtener lista de delegados"""
    delegados = db.query(Usuario).filter(Usuario.user_rol == "Delegado").offset(skip).limit(limit).all()
    return delegados
