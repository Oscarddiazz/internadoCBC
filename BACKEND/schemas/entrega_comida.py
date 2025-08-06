from pydantic import BaseModel
from datetime import datetime
from enum import Enum

class TipoComida(str, Enum):
    DESAYUNO = "Desayuno"
    ALMUERZO = "Almuerzo"
    CENA = "Cena"

class EntregaComidaBase(BaseModel):
    entcom_comida: TipoComida

class EntregaComidaCreate(EntregaComidaBase):
    entcom_delegado_id: int
    entcom_aprendiz_id: int

class EntregaComidaUpdate(BaseModel):
    entcom_comida: TipoComida

class EntregaComidaResponse(EntregaComidaBase):
    entcom_id: int
    entcom_fec_entrega: datetime
    entcom_delegado_id: int
    entcom_aprendiz_id: int
    
    class Config:
        from_attributes = True
