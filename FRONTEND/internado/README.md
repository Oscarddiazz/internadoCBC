# 📱 Frontend Internado CBC

Aplicación Flutter optimizada para el sistema de gestión de internado CBC.

## ⚡ Inicio Rápido

### 1. Instalar dependencias
```bash
flutter pub get
```

### 2. Configurar backend
- Asegúrate de que el backend esté ejecutándose
- La app se conecta automáticamente según la plataforma:
  - **Web:** http://localhost:3000
  - **Android Emulator:** http://10.0.2.2:3000
  - **iOS Simulator:** http://localhost:3000

### 3. Ejecutar aplicación
```bash
# Web
flutter run -d chrome

# Android
flutter run

# iOS
flutter run -d ios
```

## 🎯 Características

✅ **Autenticación completa** - Login y registro  
✅ **Gestión de usuarios** - CRUD de aprendices  
✅ **Gestión de permisos** - Solicitudes y aprobaciones  
✅ **Interfaz responsiva** - Funciona en web y móvil  
✅ **Configuración automática** - Se conecta automáticamente al backend  
✅ **Código optimizado** - Solo funcionalidades esenciales  

## 📱 Pantallas Principales

- **Splash** - Pantalla de carga
- **Welcome** - Pantalla de bienvenida
- **Login/Register** - Autenticación
- **Home** - Pantalla principal
- **Admin Dashboard** - Panel de administración
- **Configuración** - Ajustes de la app

## 🔧 Configuración

### Cambiar IP del backend
```dart
// En lib/config/network_config.dart
NetworkConfig.setLocalIP('192.168.1.100');
```

### Cambiar puerto
```dart
NetworkConfig.setPort(8080);
```

## 📦 Dependencias Principales

- `http` - Peticiones HTTP
- `shared_preferences` - Almacenamiento local
- `flutter/material` - UI Material Design

## 🚀 Estructura Optimizada

```
lib/
├── config/           # Configuración de red y app
├── models/           # Modelos de datos
├── routes/           # Rutas de navegación
├── screens/          # Pantallas de la app
├── services/         # Servicios de API
└── utils/            # Utilidades
```

---
**¡App optimizada y lista para usar! 🎉**