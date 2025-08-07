from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class PermisoBase(BaseModel):
    permiso_motivo: str
    permiso_evidencia: Optional[str] = None
    permiso_admin_id: int
    permiso_aprendiz_id: int

class PermisoCreate(PermisoBase):
    pass

class Permiso(PermisoBase):
    permiso_id: int
    permiso_fec_solic: datetime
    permiso_fec_res: Optional[datetime] = None

    class Config:
        from_attributes = True