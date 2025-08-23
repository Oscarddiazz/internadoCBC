from pydantic import BaseModel
from datetime import datetime
from enum import Enum

class ComidaType(str, Enum):
    desayuno = "Desayuno"
    almuerzo = "Almuerzo"
    cena = "Cena"

class EntregaComidaBase(BaseModel):
    entcom_comida: ComidaType
    entcom_delegado_id: int
    entcom_aprendiz_id: int

class EntregaComidaCreate(EntregaComidaBase):
    pass

class EntregaComida(EntregaComidaBase):
    entcom_id: int
    entcom_fec_entrega: datetime

    class Config:
        from_attributes = True