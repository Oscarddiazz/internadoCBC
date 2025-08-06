from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from database import get_db
from auth import authenticate_user, create_access_token, get_password_hash
from models.usuario import Usuario
from schemas.usuario import UsuarioCreate, UsuarioResponse
from datetime import timedelta
from config import settings

router = APIRouter(prefix="/auth", tags=["Autenticación"])

@router.post("/login")
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    """Endpoint para iniciar sesión"""
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email o contraseña incorrectos",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": str(user.user_id)}, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "user_id": user.user_id,
            "user_name": user.user_name,
            "user_ape": user.user_ape,
            "user_email": user.user_email,
            "user_rol": user.user_rol
        }
    }

@router.post("/register", response_model=UsuarioResponse)
async def register(
    usuario: UsuarioCreate,
    db: Session = Depends(get_db)
):
    """Endpoint para registrar un nuevo usuario"""
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
