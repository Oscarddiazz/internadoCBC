from sqlalchemy import Column, Integer, Enum, DateTime, ForeignKey
from app.database import Base
from datetime import datetime
import enum

class ComidaType(str, enum.Enum):
    desayuno = "Desayuno"
    almuerzo = "Almuerzo"
    cena = "Cena"

class EntregaComida(Base):
    __tablename__ = "entrega_comida"

    entcom_id = Column(Integer, primary_key=True, index=True)
    entcom_fec_entrega = Column(DateTime, default=datetime.utcnow)
    entcom_comida = Column(Enum(ComidaType), nullable=False)
    entcom_delegado_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)
    entcom_aprendiz_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)