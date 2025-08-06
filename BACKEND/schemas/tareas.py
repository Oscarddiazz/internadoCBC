from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime
from enum import Enum

class TareaEstado(str, Enum):
    PENDIENTE = "Pendiente"
    EN_PROCESO = "En Proceso"
    COMPLETADA = "Completada"

class TareasBase(BaseModel):
    tarea_descripcion: str
    tarea_fec_entrega: date
    tarea_estado: TareaEstado = TareaEstado.PENDIENTE

class TareasCreate(TareasBase):
    tarea_admin_id: int
    tarea_aprendiz_id: int

class TareasUpdate(BaseModel):
    tarea_descripcion: Optional[str] = None
    tarea_fec_entrega: Optional[date] = None
    tarea_estado: Optional[TareaEstado] = None
    tarea_evidencia: Optional[str] = None
    tarea_fec_completado: Optional[datetime] = None

class TareasResponse(TareasBase):
    tarea_id: int
    tarea_fec_asignacion: datetime
    tarea_evidencia: Optional[str] = None
    tarea_fec_completado: Optional[datetime] = None
    tarea_admin_id: int
    tarea_aprendiz_id: int
    
    class Config:
        from_attributes = True
