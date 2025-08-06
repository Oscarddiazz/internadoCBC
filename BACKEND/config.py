from decouple import config
from typing import Optional

class Settings:
    # Configuración de la base de datos
    database_url: str = config('DATABASE_URL', default="mysql+pymysql://root:@localhost:3306/internadocbc")
    
    # Configuración de seguridad
    secret_key: str = config('SECRET_KEY', default="tu_clave_secreta_muy_segura_aqui_cambiala_en_produccion")
    algorithm: str = config('ALGORITHM', default="HS256")
    access_token_expire_minutes: int = config('ACCESS_TOKEN_EXPIRE_MINUTES', default=30, cast=int)
    
    # Configuración del servidor
    host: str = config('HOST', default="0.0.0.0")
    port: int = config('PORT', default=8000, cast=int)
    debug: bool = config('DEBUG', default=True, cast=bool)

settings = Settings()
