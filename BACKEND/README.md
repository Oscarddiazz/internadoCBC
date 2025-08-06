# Backend Sistema de Internado SENA

Backend modular desarrollado con FastAPI para el sistema de gestión de internado del SENA.

## 🚀 Características

- **Autenticación JWT**: Sistema seguro de autenticación con tokens JWT
- **Gestión de Usuarios**: Administradores, Delegados y Aprendices
- **Gestión de Documentos**: Subida y descarga de documentos
- **Gestión de Tareas**: Asignación, seguimiento y evidencias de tareas
- **Gestión de Permisos**: Solicitudes y aprobación de permisos
- **Control de Comidas**: Registro de entregas de comidas
- **API RESTful**: Endpoints bien documentados
- **Validación de Datos**: Esquemas Pydantic para validación
- **Base de Datos MySQL**: Con SQLAlchemy ORM

## 📋 Requisitos Previos

- Python 3.8+
- MySQL 5.7+
- pip (gestor de paquetes de Python)

## 🛠️ Instalación

1. **Clonar el repositorio** (si no lo tienes ya):
```bash
git clone <url-del-repositorio>
cd SENA/BACKEND
```

2. **Crear entorno virtual**:
```bash
python -m venv venv

# En Windows:
venv\Scripts\activate

# En Linux/Mac:
source venv/bin/activate
```

3. **Instalar dependencias**:
```bash
pip install -r requirements.txt
```

4. **Configurar la base de datos**:
   - Crear una base de datos MySQL llamada `internadocbc`
   - Importar el archivo `../BASE DE DATOS/internadocbc.sql` en tu servidor MySQL
   - O ejecutar el script de inicialización (ver más abajo)

5. **Configurar variables de entorno**:
   - Crear un archivo `.env` en la carpeta `BACKEND/`
   - Configurar las variables según el archivo `config.py`

```env
DATABASE_URL=mysql+pymysql://usuario:contraseña@localhost:3306/internadocbc
SECRET_KEY=tu_clave_secreta_muy_segura_aqui_cambiala_en_produccion
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
HOST=0.0.0.0
PORT=8000
DEBUG=True
```

## 🚀 Ejecución

1. **Inicializar la base de datos** (opcional):
```bash
python init_db.py
```

2. **Ejecutar el servidor**:
```bash
python main.py
```

O usando uvicorn directamente:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

3. **Acceder a la documentación**:
   - Swagger UI: http://localhost:8000/docs
   - ReDoc: http://localhost:8000/redoc

## 📚 Estructura del Proyecto

```
BACKEND/
├── main.py                 # Aplicación principal
├── config.py              # Configuración
├── database.py            # Configuración de base de datos
├── auth.py                # Sistema de autenticación
├── requirements.txt       # Dependencias
├── init_db.py            # Script de inicialización
├── README.md             # Este archivo
├── models/               # Modelos de base de datos
│   ├── __init__.py
│   ├── usuario.py
│   ├── documento.py
│   ├── tareas.py
│   ├── permiso.py
│   └── entrega_comida.py
├── schemas/              # Esquemas Pydantic
│   ├── __init__.py
│   ├── usuario.py
│   ├── documento.py
│   ├── tareas.py
│   ├── permiso.py
│   └── entrega_comida.py
├── routers/              # Rutas de la API
│   ├── __init__.py
│   ├── auth.py
│   ├── usuarios.py
│   ├── documentos.py
│   ├── tareas.py
│   ├── permisos.py
│   └── entregas_comida.py
└── uploads/              # Archivos subidos (se crea automáticamente)
    ├── documentos/
    ├── evidencias/
    └── permisos/
```

## 🔐 Autenticación

El sistema utiliza JWT (JSON Web Tokens) para la autenticación:

1. **Registro**: `POST /auth/register`
2. **Login**: `POST /auth/login`
3. **Uso**: Incluir el token en el header: `Authorization: Bearer <token>`

### Credenciales de Prueba

Si ejecutas `init_db.py`, tendrás estos usuarios de prueba:

- **Administrador**: `pedro.suarez@sena.edu.co` / `admin123`
- **Delegado**: `juan.martinez@sena.edu.co` / `delegado1`
- **Aprendiz**: `carlos.gomez@sena.edu.co` / `aprendiz1`

## 📖 Endpoints Principales

### Autenticación
- `POST /auth/login` - Iniciar sesión
- `POST /auth/register` - Registrar usuario

### Usuarios
- `GET /usuarios/` - Listar usuarios (solo admin)
- `GET /usuarios/me` - Obtener usuario actual
- `GET /usuarios/{user_id}` - Obtener usuario específico
- `POST /usuarios/` - Crear usuario (solo admin)
- `PUT /usuarios/{user_id}` - Actualizar usuario
- `DELETE /usuarios/{user_id}` - Eliminar usuario (solo admin)

### Documentos
- `GET /documentos/` - Listar documentos
- `GET /documentos/{doc_id}` - Obtener documento
- `POST /documentos/` - Subir documento (solo admin)
- `PUT /documentos/{doc_id}` - Actualizar documento (solo admin)
- `DELETE /documentos/{doc_id}` - Eliminar documento (solo admin)

### Tareas
- `GET /tareas/` - Listar tareas
- `GET /tareas/{tarea_id}` - Obtener tarea
- `POST /tareas/` - Crear tarea (solo admin)
- `PUT /tareas/{tarea_id}` - Actualizar tarea
- `POST /tareas/{tarea_id}/evidencia` - Subir evidencia
- `DELETE /tareas/{tarea_id}` - Eliminar tarea (solo admin)

### Permisos
- `GET /permisos/` - Listar permisos
- `GET /permisos/{permiso_id}` - Obtener permiso
- `POST /permisos/` - Crear permiso
- `PUT /permisos/{permiso_id}` - Actualizar permiso
- `POST /permisos/{permiso_id}/evidencia` - Subir evidencia
- `DELETE /permisos/{permiso_id}` - Eliminar permiso (solo admin)

### Entregas de Comida
- `GET /entregas-comida/` - Listar entregas
- `GET /entregas-comida/{entcom_id}` - Obtener entrega
- `POST /entregas-comida/` - Crear entrega (delegados/admin)
- `PUT /entregas-comida/{entcom_id}` - Actualizar entrega
- `DELETE /entregas-comida/{entcom_id}` - Eliminar entrega

## 🔒 Roles y Permisos

### Administrador
- Acceso completo a todas las funcionalidades
- Puede gestionar usuarios, documentos, tareas, permisos y entregas
- Puede responder solicitudes de permisos

### Delegado
- Puede gestionar entregas de comida
- Puede ver tareas y permisos
- Acceso limitado a gestión de usuarios

### Aprendiz
- Puede ver sus propias tareas y permisos
- Puede solicitar permisos
- Puede subir evidencias de tareas
- Acceso de solo lectura a documentos

## 📁 Gestión de Archivos

Los archivos se almacenan en la carpeta `uploads/` con la siguiente estructura:
- `uploads/documentos/` - Documentos del sistema
- `uploads/evidencias/` - Evidencias de tareas
- `uploads/permisos/` - Evidencias de permisos

## 🐛 Solución de Problemas

### Error de conexión a la base de datos
- Verificar que MySQL esté ejecutándose
- Verificar las credenciales en `config.py`
- Verificar que la base de datos `internadocbc` exista

### Error de dependencias
- Asegurarse de que el entorno virtual esté activado
- Ejecutar `pip install -r requirements.txt`

### Error de permisos
- Verificar que el usuario tenga los permisos correctos en la base de datos
- Verificar que las carpetas `uploads/` tengan permisos de escritura

## 🔧 Desarrollo

### Agregar nuevos endpoints
1. Crear el modelo en `models/`
2. Crear los esquemas en `schemas/`
3. Crear el router en `routers/`
4. Incluir el router en `main.py`

### Modificar la base de datos
1. Actualizar los modelos en `models/`
2. Ejecutar las migraciones necesarias
3. Actualizar los esquemas si es necesario

## 📄 Licencia

Este proyecto está desarrollado para el SENA.

## 🤝 Contribución

Para contribuir al proyecto:
1. Crear una rama para tu feature
2. Hacer los cambios necesarios
3. Probar que todo funcione correctamente
4. Crear un pull request

## 📞 Soporte

Para soporte técnico, contactar al equipo de desarrollo del SENA.
