from sqlalchemy import Column, Integer, String, DateTime, Date, ForeignKey, Enum, Text
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class Tareas(Base):
    __tablename__ = "tareas"
    
    tarea_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    tarea_descripcion = Column(Text, nullable=False)
    tarea_fec_asignacion = Column(DateTime, default=datetime.utcnow)
    tarea_fec_entrega = Column(Date, nullable=False)
    tarea_estado = Column(Enum('Pendiente', 'En Proceso', 'Completada'), nullable=False)
    tarea_evidencia = Column(String(255), nullable=True)
    tarea_fec_completado = Column(DateTime, nullable=True)
    tarea_admin_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)
    tarea_aprendiz_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)
    
    # Relaciones
    admin = relationship("Usuario", foreign_keys=[tarea_admin_id], back_populates="tareas_asignadas")
    aprendiz = relationship("Usuario", foreign_keys=[tarea_aprendiz_id], back_populates="tareas_recibidas")
