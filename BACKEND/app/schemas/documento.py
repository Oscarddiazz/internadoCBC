from pydantic import BaseModel
from datetime import datetime

class DocumentoBase(BaseModel):
    doc_nombre: str
    doc_archivo: str
    doc_admin_id: int

class DocumentoCreate(DocumentoBase):
    pass

class Documento(DocumentoBase):
    doc_id: int
    doc_fec_subida: datetime

    class Config:
        from_attributes = True