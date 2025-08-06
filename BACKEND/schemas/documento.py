from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class DocumentoBase(BaseModel):
    doc_nombre: str
    doc_archivo: str

class DocumentoCreate(DocumentoBase):
    doc_admin_id: int

class DocumentoUpdate(BaseModel):
    doc_nombre: Optional[str] = None
    doc_archivo: Optional[str] = None

class DocumentoResponse(DocumentoBase):
    doc_id: int
    doc_fec_subida: datetime
    doc_admin_id: int
    
    class Config:
        from_attributes = True
