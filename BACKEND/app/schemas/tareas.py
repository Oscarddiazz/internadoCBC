from pydantic import BaseModel
from datetime import datetime, date
from enum import Enum
from typing import Optional

class TareaEstado(str, Enum):
    pendiente = "Pendiente"
    en_proceso = "En Proceso"
    completada = "Completada"

class TareaBase(BaseModel):
    tarea_descripcion: str
    tarea_fec_entrega: date
    tarea_estado: TareaEstado
    tarea_evidencia: Optional[str] = None
    tarea_admin_id: int
    tarea_aprendiz_id: int

class TareaCreate(TareaBase):
    pass

class Tarea(TareaBase):
    tarea_id: int
    tarea_fec_asignacion: datetime
    tarea_fec_completado: Optional[datetime] = None

    class Config:
        from_attributes = True