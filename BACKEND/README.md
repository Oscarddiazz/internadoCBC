# Backend - Sistema de Gestión de Internado CBC

Este es el backend del sistema de gestión de internado desarrollado con Node.js, Express y MySQL.

## 🚀 Características

- **Autenticación JWT**: Sistema seguro de autenticación con tokens
- **Gestión de usuarios**: CRUD completo para usuarios (Administrador, Delegado, Aprendiz)
- **Gestión de tareas**: Asignación, seguimiento y completado de tareas
- **Roles y permisos**: Sistema de autorización basado en roles
- **Base de datos MySQL**: Integración con XAMPP/MySQL
- **Seguridad**: Helmet, rate limiting, CORS configurado
- **Validación**: Validación de datos de entrada
- **Manejo de errores**: Sistema robusto de manejo de errores

## 📋 Requisitos Previos

- Node.js (versión 14 o superior)
- XAMPP (con MySQL)
- Base de datos `internadocbc` importada

## 🛠️ Instalación

1. **Clonar el repositorio**:
   ```bash
   cd backend
   ```

2. **Instalar dependencias**:
   ```bash
   npm install
   ```

3. **Configurar variables de entorno**:
   - Editar el archivo `config.env`
   - Ajustar la configuración de la base de datos según tu XAMPP

4. **Iniciar XAMPP**:
   - Iniciar Apache y MySQL
   - Importar la base de datos `internadocbc.sql`

5. **Iniciar el servidor**:
   ```bash
   npm run dev
   ```

## ⚙️ Configuración

### Variables de Entorno (`config.env`)

```env
# Base de datos
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=internadocbc
DB_PORT=3306

# Servidor
PORT=3000
NODE_ENV=development

# JWT
JWT_SECRET=tu_secret_key_aqui
JWT_EXPIRES_IN=24h

# Archivos
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=5242880
```

## 📚 API Endpoints

### Autenticación (`/api/auth`)

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| POST | `/login` | Iniciar sesión | No |
| GET | `/profile` | Obtener perfil | Sí |
| PUT | `/change-password` | Cambiar contraseña | Sí |

### Usuarios (`/api/users`)

| Método | Endpoint | Descripción | Rol Requerido |
|--------|----------|-------------|---------------|
| GET | `/` | Obtener todos los usuarios | Administrador |
| GET | `/:id` | Obtener usuario por ID | Administrador |
| POST | `/` | Crear nuevo usuario | Administrador |
| PUT | `/:id` | Actualizar usuario | Administrador |
| DELETE | `/:id` | Eliminar usuario | Administrador |

### Tareas (`/api/tasks`)

| Método | Endpoint | Descripción | Rol Requerido |
|--------|----------|-------------|---------------|
| GET | `/` | Obtener todas las tareas | Todos |
| GET | `/:id` | Obtener tarea por ID | Todos |
| POST | `/` | Crear nueva tarea | Admin/Delegado |
| PUT | `/:id` | Actualizar tarea | Admin/Delegado |
| PUT | `/:id/complete` | Completar tarea | Todos |
| DELETE | `/:id` | Eliminar tarea | Administrador |

## 🔐 Autenticación

### Login
```json
POST /api/auth/login
{
  "email": "pedro.suarez@sena.edu.co",
  "password": "admin123"
}
```

### Headers para rutas protegidas
```
Authorization: Bearer <token_jwt>
```

## 👥 Roles y Permisos

### Administrador
- Acceso completo a todas las funcionalidades
- Gestión de usuarios
- Gestión de tareas
- Gestión de documentos

### Delegado
- Ver usuarios
- Crear y gestionar tareas
- Gestión de entrega de comida

### Aprendiz
- Ver su perfil
- Ver sus tareas asignadas
- Completar tareas
- Solicitar permisos

## 🗄️ Estructura de la Base de Datos

### Tablas principales:
- `usuario`: Información de usuarios
- `tareas`: Gestión de tareas asignadas
- `permiso`: Solicitudes de permisos
- `documento`: Documentos del sistema
- `entrega_comida`: Control de entrega de comida

## 🚀 Scripts Disponibles

```bash
# Desarrollo
npm run dev

# Producción
npm start

# Instalar dependencias
npm install
```

## 🔧 Desarrollo

### Estructura del Proyecto
```
backend/
├── config/
│   └── database.js
├── controllers/
│   ├── authController.js
│   ├── userController.js
│   └── taskController.js
├── middleware/
│   └── auth.js
├── routes/
│   ├── auth.js
│   ├── users.js
│   └── tasks.js
├── uploads/
├── config.env
├── package.json
├── server.js
└── README.md
```

### Agregar Nuevos Endpoints

1. Crear controlador en `controllers/`
2. Crear rutas en `routes/`
3. Registrar rutas en `server.js`

## 🐛 Solución de Problemas

### Error de conexión a la base de datos
- Verificar que XAMPP esté ejecutándose
- Confirmar credenciales en `config.env`
- Verificar que la base de datos `internadocbc` exista

### Error de CORS
- Verificar configuración de CORS en `server.js`
- Agregar tu dominio a la lista de orígenes permitidos

### Error de JWT
- Verificar que `JWT_SECRET` esté configurado
- Confirmar que el token se envíe en el header `Authorization`

## 📞 Soporte

Para soporte técnico o preguntas sobre el backend, contacta al equipo de desarrollo.

## 📄 Licencia

Este proyecto está bajo la licencia MIT.
