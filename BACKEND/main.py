from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os
from database import engine
from models import usuario, documento, tareas, permiso, entrega_comida
from routers import (
    auth_router,
    usuarios_router,
    documentos_router,
    tareas_router,
    permisos_router,
    entregas_comida_router
)
from config import settings

# Crear las tablas en la base de datos
usuario.Base.metadata.create_all(bind=engine)
documento.Base.metadata.create_all(bind=engine)
tareas.Base.metadata.create_all(bind=engine)
permiso.Base.metadata.create_all(bind=engine)
entrega_comida.Base.metadata.create_all(bind=engine)

# Crear la aplicación FastAPI
app = FastAPI(
    title="API Sistema de Internado SENA",
    description="API para gestión del sistema de internado del SENA",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especificar los orígenes permitidos
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Crear directorios para archivos estáticos
os.makedirs("uploads", exist_ok=True)
os.makedirs("uploads/documentos", exist_ok=True)
os.makedirs("uploads/evidencias", exist_ok=True)
os.makedirs("uploads/permisos", exist_ok=True)

# Montar archivos estáticos
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# Incluir routers
app.include_router(auth_router)
app.include_router(usuarios_router)
app.include_router(documentos_router)
app.include_router(tareas_router)
app.include_router(permisos_router)
app.include_router(entregas_comida_router)

@app.get("/")
async def root():
    """Endpoint raíz de la API"""
    return {
        "message": "Bienvenido a la API del Sistema de Internado SENA",
        "version": "1.0.0",
        "docs": "/docs",
        "redoc": "/redoc"
    }

@app.get("/health")
async def health_check():
    """Endpoint para verificar el estado de la API"""
    return {
        "status": "healthy",
        "message": "La API está funcionando correctamente"
    }

@app.exception_handler(404)
async def not_found_handler(request, exc):
    """Manejador para rutas no encontradas"""
    return HTTPException(
        status_code=404,
        detail="Ruta no encontrada"
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.debug
    )
