from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date, datetime
from enum import Enum

class UserRol(str, Enum):
    ADMINISTRADOR = "Administrador"
    DELEGADO = "Delegado"
    APRENDIZ = "Aprendiz"

class UserDiscap(str, Enum):
    VISUAL = "Visual"
    AUDITIVA = "Auditiva"
    FISICA = "Fisica"
    NINGUNA = "Ninguna"

class EtpFormApr(str, Enum):
    LECTIVA = "Lectiva"
    PRODUCTIVA = "Productiva"

class UserGen(str, Enum):
    MASCULINO = "Masculino"
    FEMENINO = "Femenino"

class UserEtn(str, Enum):
    INDIGINA = "Indigina"
    AFRODESCENDIENTE = "Afrodescendiente"
    NO_APLICA = "No Aplica"

class UsuarioBase(BaseModel):
    user_num_ident: str
    user_name: str
    user_ape: str
    user_email: EmailStr
    user_tel: Optional[str] = None
    user_rol: UserRol
    user_discap: UserDiscap
    etp_form_Apr: EtpFormApr
    user_gen: UserGen
    user_etn: UserEtn
    user_img: str
    fec_ini_form_Apr: date
    fec_fin_form_Apr: date
    ficha_Apr: int

class UsuarioCreate(UsuarioBase):
    user_pass: str

class UsuarioUpdate(BaseModel):
    user_name: Optional[str] = None
    user_ape: Optional[str] = None
    user_email: Optional[EmailStr] = None
    user_tel: Optional[str] = None
    user_pass: Optional[str] = None
    user_rol: Optional[UserRol] = None
    user_discap: Optional[UserDiscap] = None
    etp_form_Apr: Optional[EtpFormApr] = None
    user_gen: Optional[UserGen] = None
    user_etn: Optional[UserEtn] = None
    user_img: Optional[str] = None
    fec_ini_form_Apr: Optional[date] = None
    fec_fin_form_Apr: Optional[date] = None
    ficha_Apr: Optional[int] = None

class UsuarioResponse(UsuarioBase):
    user_id: int
    fec_registro: datetime
    
    class Config:
        from_attributes = True

class UsuarioLogin(BaseModel):
    user_email: EmailStr
    user_pass: str
