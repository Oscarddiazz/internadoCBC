from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    # Configuración de la base de datos
    database_url: str = "mysql+pymysql://root:@localhost:3306/internadocbc"
    
    # Configuración de seguridad
    secret_key: str = "tu_clave_secreta_muy_segura_aqui_cambiala_en_produccion"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Configuración del servidor
    host: str = "0.0.0.0"
    port: int = 8000
    debug: bool = True
    
    class Config:
        env_file = ".env"

settings = Settings()
