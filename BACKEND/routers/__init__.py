from .auth import router as auth_router
from .usuarios import router as usuarios_router
from .documentos import router as documentos_router
from .tareas import router as tareas_router
from .permisos import router as permisos_router
from .entregas_comida import router as entregas_comida_router

__all__ = [
    "auth_router",
    "usuarios_router", 
    "documentos_router",
    "tareas_router",
    "permisos_router",
    "entregas_comida_router"
]
