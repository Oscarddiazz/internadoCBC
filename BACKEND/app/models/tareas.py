from sqlalchemy import Column, Integer, Text, DateTime, Date, Enum, String, ForeignKey
from app.database import Base
from datetime import datetime
import enum

class TareaEstado(str, enum.Enum):
    pendiente = "Pendiente"
    en_proceso = "En Proceso"
    completada = "Completada"

class Tarea(Base):
    __tablename__ = "tareas"

    tarea_id = Column(Integer, primary_key=True, index=True)
    tarea_descripcion = Column(Text, nullable=False)
    tarea_fec_asignacion = Column(DateTime, default=datetime.utcnow)
    tarea_fec_entrega = Column(Date, nullable=False)
    tarea_estado = Column(Enum(TareaEstado), nullable=False)
    tarea_evidencia = Column(String(255), nullable=True)
    tarea_fec_completado = Column(DateTime, nullable=True)
    tarea_admin_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)
    tarea_aprendiz_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)