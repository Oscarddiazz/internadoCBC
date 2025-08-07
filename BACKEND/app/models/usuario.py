from sqlalchemy import Column, Integer, String, Enum, Date, DateTime
from app.database import Base
from datetime import datetime
import enum

class RolType(str, enum.Enum):
    administrador = "Administrador"
    delegado = "Delegado"
    aprendiz = "Aprendiz"

class DiscapacidadType(str, enum.Enum):
    visual = "Visual"
    auditiva = "Auditiva"
    fisica = "Fisica"
    ninguna = "Ninguna"

class EtapaType(str, enum.Enum):
    lectiva = "Lectiva"
    productiva = "Productiva"

class GeneroType(str, enum.Enum):
    masculino = "Masculino"
    femenino = "Femenino"

class EtniaType(str, enum.Enum):
    indigina = "Indigina"
    afrodescendiente = "Afrodescendiente"
    no_aplica = "No Aplica"

class Usuario(Base):
    __tablename__ = "usuario"

    user_id = Column(Integer, primary_key=True, index=True)
    user_num_ident = Column(String(50), unique=True, nullable=False)
    user_name = Column(String(100), nullable=False)
    user_ape = Column(String(100), nullable=False)
    user_email = Column(String(255), unique=True, nullable=False)
    user_tel = Column(String(15), nullable=True)
    user_pass = Column(String(100), nullable=False)
    user_rol = Column(Enum(RolType), nullable=False)
    user_discap = Column(Enum(DiscapacidadType), nullable=False)
    etp_form_Apr = Column(Enum(EtapaType), nullable=False)
    user_gen = Column(Enum(GeneroType), nullable=False)
    user_etn = Column(Enum(EtniaType), nullable=False)
    user_img = Column(String(250), nullable=False)
    fec_ini_form_Apr = Column(Date, nullable=False)
    fec_fin_form_Apr = Column(Date, nullable=False)
    ficha_Apr = Column(Integer, nullable=False)
    fec_registro = Column(DateTime, default=datetime.utcnow)