from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class EntregaComida(Base):
    __tablename__ = "entrega_comida"
    
    entcom_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    entcom_fec_entrega = Column(DateTime, default=datetime.utcnow)
    entcom_comida = Column(Enum('Desayuno', 'Almuerzo', 'Cena'), nullable=False)
    entcom_delegado_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)
    entcom_aprendiz_id = Column(Integer, ForeignKey("usuario.user_id"), nullable=False)
    
    # Relaciones
    delegado = relationship("Usuario", foreign_keys=[entcom_delegado_id], back_populates="entregas_comida_delegado")
    aprendiz = relationship("Usuario", foreign_keys=[entcom_aprendiz_id], back_populates="entregas_comida_aprendiz")
