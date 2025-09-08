# 🚀 Backend Internado CBC

Backend optimizado para el sistema de gestión de internado CBC.

## ⚡ Inicio Rápido

### 1. Instalar dependencias
```bash
npm install
```

### 2. Configurar base de datos
- Crear base de datos `internadocbc` en MySQL
- Configurar credenciales en `config.env`

### 3. Iniciar servidor
```bash
# Inicio normal
npm start

# Modo desarrollo
npm run dev

# O usar el script de Windows
start.bat
```

## 🌐 URLs de Acceso

- **Web:** http://localhost:3000
- **Android Emulator:** http://10.0.2.2:3000
- **Estado:** http://localhost:3000/health

## 📋 Endpoints

- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/register` - Registro
- `GET /api/auth/profile` - Perfil del usuario
- `GET /api/users` - Listar usuarios
- `GET /api/tasks` - Listar tareas
- `GET /api/permissions` - Listar permisos

## ⚙️ Configuración

Editar `config.env`:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=tu_password
DB_NAME=internadocbc
PORT=3000
```

## 🔧 Características

✅ Funciona en cualquier puerto  
✅ Soporte para emulador Android  
✅ CORS configurado automáticamente  
✅ Autenticación JWT  
✅ Base de datos MySQL  
✅ Código optimizado y limpio  

---
**¡Listo para usar! 🎉**