from sqlalchemy import Column, Integer, String, DateTime, Date, Enum
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class Usuario(Base):
    __tablename__ = "usuario"
    
    user_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_num_ident = Column(String(50), unique=True, nullable=False, index=True)
    user_name = Column(String(100), nullable=False)
    user_ape = Column(String(100), nullable=False)
    user_email = Column(String(255), unique=True, nullable=False, index=True)
    user_tel = Column(String(15), nullable=True)
    user_pass = Column(String(100), nullable=False)
    user_rol = Column(Enum('Administrador', 'Delegado', 'Aprendiz'), nullable=False)
    user_discap = Column(Enum('Visual', 'Auditiva', 'Fisica', 'Ninguna'), nullable=False)
    etp_form_Apr = Column(Enum('Lectiva', 'Productiva'), nullable=False)
    user_gen = Column(Enum('Masculino', 'Femenino'), nullable=False)
    user_etn = Column(Enum('Indigina', 'Afrodescendiente', 'No Aplica'), nullable=False)
    user_img = Column(String(250), nullable=False)
    fec_ini_form_Apr = Column(Date, nullable=False)
    fec_fin_form_Apr = Column(Date, nullable=False)
    ficha_Apr = Column(Integer, nullable=False)
    fec_registro = Column(DateTime, default=datetime.utcnow)
    
    # Relaciones
    documentos = relationship("Documento", back_populates="admin")
    tareas_asignadas = relationship("Tareas", foreign_keys="Tareas.tarea_admin_id", back_populates="admin")
    tareas_recibidas = relationship("Tareas", foreign_keys="Tareas.tarea_aprendiz_id", back_populates="aprendiz")
    permisos_solicitados = relationship("Permiso", foreign_keys="Permiso.permiso_aprendiz_id", back_populates="aprendiz")
    permisos_aprobados = relationship("Permiso", foreign_keys="Permiso.permiso_admin_id", back_populates="admin")
    entregas_comida_delegado = relationship("EntregaComida", foreign_keys="EntregaComida.entcom_delegado_id", back_populates="delegado")
    entregas_comida_aprendiz = relationship("EntregaComida", foreign_keys="EntregaComida.entcom_aprendiz_id", back_populates="aprendiz")
