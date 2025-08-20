from fastapi import FastAPI
from app.routers import documento, entrega_comida, permiso, tareas, usuario
from app.database import engine
from app.models import documento as documento_model, entrega_comida as entrega_comida_model, permiso as permiso_model, tareas as tareas_model, usuario as usuario_model

app = FastAPI(title="InternadoCBC API", description="API for managing InternadoCBC database", version="1.0.0")

# Create database tables
documento_model.Base.metadata.create_all(bind=engine)
entrega_comida_model.Base.metadata.create_all(bind=engine)
permiso_model.Base.metadata.create_all(bind=engine)
tareas_model.Base.metadata.create_all(bind=engine)
usuario_model.Base.metadata.create_all(bind=engine)

# Include routers
app.include_router(documento, prefix="/documentos", tags=["Documentos"])
app.include_router(entrega_comida, prefix="/entrega_comida", tags=["Entrega Comida"])
app.include_router(permiso, prefix="/permisos", tags=["Permisos"])
app.include_router(tareas, prefix="/tareas", tags=["Tareas"])
app.include_router(usuario, prefix="/usuarios", tags=["Usuarios"])

@app.get("/")
async def root():
    return {"message": "Welcome to InternadoCBC API"}