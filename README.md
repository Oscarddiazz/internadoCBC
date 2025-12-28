# 🚀 BioHub - Sistema de Internado CBC

Sistema de gestión de internado que funciona en **emulador Android** y **web** sin configuración adicional.

## ✅ Configuración Automática

La aplicación detecta automáticamente la plataforma y usa la URL correcta:

- **Emulador Android**: `http://10.0.2.2:3000/api` ✅
- **Web (Chrome)**: `http://localhost:3000/api` ✅
- **iOS Simulator**: `http://localhost:3000/api` ✅

## 🚀 Inicio Rápido

### 1. Iniciar Backend
```bash
cd BACKEND
npm start
```

### 2. Iniciar Frontend

**Para Emulador Android:**
```bash
cd FRONTEND/internado
flutter run
```

**Para Web:**
```bash
cd FRONTEND/internado
flutter run -d chrome
```

## 📱 Credenciales de Prueba

| Rol | Email | Contraseña |
|-----|-------|------------|
| Admin | pedro.suarez@sena.edu.co | admin123 |
| Delegado | juan.martinez@sena.edu.co | delegado1 |
| Aprendiz | carlos.gomez@sena.edu.co | aprendiz1 |

## 🔧 Scripts de Inicio

### Windows
```bash
start_app.bat
```

### Linux/Mac
```bash
./start_app.sh
```

## 📊 URLs Importantes

- **API Backend**: http://localhost:3000
- **Estado API**: http://localhost:3000/health
- **Documentación**: http://localhost:3000

## 📱 Para Dispositivos Físicos

Si quieres usar un dispositivo físico, cambia la IP en `FRONTEND/internado/lib/config/app_config.dart`:

```dart
// Cambia esta IP por la IP de tu computadora
return 'http://TU_IP_AQUI:3000/api';
```

Para encontrar tu IP:
- **Windows**: `ipconfig` en CMD
- **Mac/Linux**: `ifconfig` en Terminal

## 🎯 Funcionalidades

- ✅ Autenticación de usuarios
- ✅ Gestión de aprendices
- ✅ Gestión de tareas
- ✅ Gestión de permisos
- ✅ Interfaz responsive
- ✅ Funciona en emulador y web

---

**¡Listo! La aplicación funciona inmediatamente sin configuración adicional.**
