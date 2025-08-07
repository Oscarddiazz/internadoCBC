from sqlalchemy import Column, Integer, Text, String, DateTime, ForeignKey
from app.database import Base
from datetime import datetime

class Permiso(Base):
    __tablename__ = "permiso"

    permiso_id = Column(Integer, primary_key=True, index=True)
    permiso_motivo = Column(Text, nullable=False)
    permiso_evidencia = Column(String(255), nullable=True)
    permiso_fec_solic = Column(DateTime, default=datetime.utcnow)
    permiso_fec_res = Column(DateTime, nullable=True)
    permiso_admin_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)
    permiso_aprendiz_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)