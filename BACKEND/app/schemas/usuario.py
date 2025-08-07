from pydantic import BaseModel
from datetime import datetime, date
from enum import Enum

class RolType(str, Enum):
    administrador = "Administrador"
    delegado = "Delegado"
    aprendiz = "Aprendiz"

class DiscapacidadType(str, Enum):
    visual = "Visual"
    auditiva = "Auditiva"
    fisica = "Fisica"
    ninguna = "Ninguna"

class EtapaType(str, Enum):
    lectiva = "Lectiva"
    productiva = "Productiva"

class GeneroType(str, Enum):
    masculino = "Masculino"
    femenino = "Femenino"

class EtniaType(str, Enum):
    indigina = "Indigina"
    afrodescendiente = "Afrodescendiente"
    no_aplica = "No Aplica"

class UsuarioBase(BaseModel):
    user_num_ident: str
    user_name: str
    user_ape: str
    user_email: str
    user_tel: str | None = None
    user_pass: str
    user_rol: RolType
    user_discap: DiscapacidadType
    etp_form_Apr: EtapaType
    user_gen: GeneroType
    user_etn: EtniaType
    user_img: str
    fec_ini_form_Apr: date
    fec_fin_form_Apr: date
    ficha_Apr: int

class UsuarioCreate(UsuarioBase):
    pass

class Usuario(UsuarioBase):
    user_id: int
    fec_registro: datetime

    class Config:
        from_attributes = True