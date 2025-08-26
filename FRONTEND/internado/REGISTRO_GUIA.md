# Guía del Sistema de Registro - BioHub

## Descripción General

El sistema de registro de BioHub funciona en dos pasos para recopilar toda la información necesaria del usuario de manera organizada y eficiente.

## Flujo de Registro

### Paso 1: Información Básica (`register_screen.dart`)

**Campos requeridos:**
- **Nombre**: Nombre del usuario
- **Apellidos**: Apellidos del usuario
- **Email**: Correo electrónico (debe ser único)
- **Teléfono**: Número de teléfono
- **Contraseña**: 
  - Mínimo 8 caracteres
  - Debe contener al menos una mayúscula
  - Debe contener al menos una minúscula
  - Debe contener al menos un número
  - Puede contener caracteres especiales
- **Rol**: 
  - Estudiante
  - Administrador
  - Docente
- **Términos y Condiciones**: Debe ser aceptado

**Validaciones:**
- Todos los campos son obligatorios
- La contraseña debe cumplir con los requisitos de seguridad
- El email debe tener formato válido
- Los términos y condiciones deben ser aceptados

### Paso 2: Información Adicional (`register_step2_screen.dart`)

**Campos requeridos:**
- **Discapacidad**: 
  - Ninguna
  - Física
  - Visual
  - Auditiva
  - Cognitiva
- **Etnia**:
  - No Aplica
  - Indígena
  - Afrodescendiente
  - Rom
  - Raizal
  - Palenquero
- **Género**:
  - Masculino
  - Femenino
  - No Binario
  - Prefiero no decir
- **Tipo de Documento**:
  - Cédula de Ciudadanía
  - Tarjeta de Identidad
  - Cédula de Extranjería
  - Pasaporte
- **Documento**: Número de identificación
- **Foto de Perfil**: Opcional (máximo 500kb)

**Validaciones:**
- Documento y Tipo de Documento son obligatorios
- Género es obligatorio
- Los demás campos tienen valores por defecto si no se seleccionan

## Conexión con Base de Datos

### Backend (Node.js + Express + MySQL)

**Endpoints utilizados:**
- `POST /api/auth/register` - Registro de usuario

**Estructura de datos enviada:**
```json
{
  "user_num_ident": "12345678",
  "user_name": "Juan",
  "user_ape": "Pérez",
  "user_email": "juan.perez@email.com",
  "user_tel": "3001234567",
  "user_pass": "Contraseña123",
  "user_rol": "Estudiante",
  "user_discap": "Ninguna",
  "user_gen": "Masculino",
  "user_etn": "No Aplica",
  "user_img": "default.png",
  "tipo_documento": "Cédula de Ciudadanía"
}
```

### Frontend (Flutter)

**Servicios utilizados:**
- `AuthService.register()` - Maneja el registro
- `ApiService.register()` - Comunica con el backend

**Almacenamiento:**
- Token JWT se guarda en SharedPreferences
- Datos del usuario se guardan localmente
- Navegación automática según el rol del usuario

## Términos y Condiciones

### Ubicación: `lib/utils/terminos_condiciones.dart`

**Contenido incluye:**
- Aceptación de términos
- Descripción del servicio
- Registro y cuenta de usuario
- Uso aceptable
- Privacidad y protección de datos
- Propiedad intelectual
- Limitación de responsabilidad
- Modificaciones
- Terminación
- Disposiciones generales
- Información de contacto

**Funcionalidad:**
- Se muestra en un diálogo modal
- Texto completo con scroll
- Botón "Cerrar" para cerrar el diálogo
- Checkbox obligatorio en el formulario

## Manejo de Errores

### Tipos de errores manejados:
1. **Campos vacíos**: Mensajes específicos para cada campo
2. **Validación de contraseña**: Requisitos de seguridad
3. **Email duplicado**: Usuario ya registrado
4. **Error de conexión**: Problemas de red
5. **Timeout**: Tiempo de espera agotado
6. **Error del servidor**: Problemas en el backend

### Mensajes de usuario:
- **Naranja**: Advertencias y validaciones
- **Rojo**: Errores críticos
- **Verde**: Éxito en operaciones

## Navegación Post-Registro

### Según el rol del usuario:
- **Administrador**: Redirige a `/admin-dashboard`
- **Estudiante/Docente**: Redirige a `/home`

### Flujo de autenticación:
1. Registro exitoso
2. Token JWT generado
3. Datos guardados localmente
4. Navegación automática
5. Sesión activa

## Configuración

### Archivos de configuración:
- `lib/config/app_config.dart` - Configuración general
- `backend/config.env` - Variables de entorno del backend

### URLs de conexión:
- **Emulador Android**: `http://10.0.2.2:3000/api`
- **Dispositivo físico**: `http://[IP_COMPUTADORA]:3000/api`
- **Web/iOS Simulator**: `http://localhost:3000/api`

## Seguridad

### Medidas implementadas:
- Validación de contraseñas robusta
- Tokens JWT para autenticación
- Validación de datos en frontend y backend
- Manejo seguro de errores
- Almacenamiento seguro de credenciales

### Recomendaciones:
- Cambiar contraseñas regularmente
- No compartir credenciales
- Cerrar sesión en dispositivos públicos
- Mantener la aplicación actualizada
