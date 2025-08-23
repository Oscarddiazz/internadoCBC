from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from app.database import Base
from datetime import datetime

class Documento(Base):
    __tablename__ = "documento"

    doc_id = Column(Integer, primary_key=True, index=True)
    doc_nombre = Column(String(255), nullable=False)
    doc_archivo = Column(String(255), nullable=False)
    doc_fec_subida = Column(DateTime, default=datetime.utcnow)
    doc_admin_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)