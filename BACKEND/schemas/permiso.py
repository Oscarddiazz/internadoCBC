from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class PermisoBase(BaseModel):
    permiso_motivo: str
    permiso_evidencia: Optional[str] = None

class PermisoCreate(PermisoBase):
    permiso_admin_id: int
    permiso_aprendiz_id: int

class PermisoUpdate(BaseModel):
    permiso_motivo: Optional[str] = None
    permiso_evidencia: Optional[str] = None
    permiso_fec_res: Optional[datetime] = None

class PermisoResponse(PermisoBase):
    permiso_id: int
    permiso_fec_solic: datetime
    permiso_fec_res: Optional[datetime] = None
    permiso_admin_id: int
    permiso_aprendiz_id: int
    
    class Config:
        from_attributes = True
