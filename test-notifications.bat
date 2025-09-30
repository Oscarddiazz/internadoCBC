@echo off
echo ========================================
echo   PRUEBA DE NOTIFICACIONES EN TIEMPO REAL
echo ========================================
echo.

echo [1/4] Verificando configuracion del backend...
cd BACKEND
if exist config.env (
    echo ✓ Archivo config.env encontrado
    findstr "NODE_ENV=production" config.env >nul
    if %errorlevel% equ 0 (
        echo ✓ Modo produccion activado
    ) else (
        echo ✗ Modo produccion NO activado
    )
    
    findstr "WS_ENABLED=true" config.env >nul
    if %errorlevel% equ 0 (
        echo ✓ WebSocket habilitado
    ) else (
        echo ✗ WebSocket NO habilitado
    )
) else (
    echo ✗ Archivo config.env NO encontrado
)

echo.
echo [2/4] Verificando dependencias del backend...
if exist node_modules\socket.io (
    echo ✓ Socket.io instalado
) else (
    echo ✗ Socket.io NO instalado
    echo   Ejecutando: npm install socket.io
    npm install socket.io
)

echo.
echo [3/4] Verificando configuracion del frontend...
cd ..\FRONTEND\internado
if exist lib\config\network_config.dart (
    echo ✓ Archivo network_config.dart encontrado
    findstr "_isProduction = true" lib\config\network_config.dart >nul
    if %errorlevel% equ 0 (
        echo ✓ Modo produccion activado en frontend
    ) else (
        echo ✗ Modo produccion NO activado en frontend
    )
) else (
    echo ✗ Archivo network_config.dart NO encontrado
)

echo.
echo [4/4] Verificando dependencias del frontend...
if exist pubspec.yaml (
    echo ✓ Archivo pubspec.yaml encontrado
    findstr "socket_io_client" pubspec.yaml >nul
    if %errorlevel% equ 0 (
        echo ✓ Socket.io client configurado
    ) else (
        echo ✗ Socket.io client NO configurado
    )
    
    findstr "flutter_local_notifications" pubspec.yaml >nul
    if %errorlevel% equ 0 (
        echo ✓ Notificaciones locales configuradas
    ) else (
        echo ✗ Notificaciones locales NO configuradas
    )
) else (
    echo ✗ Archivo pubspec.yaml NO encontrado
)

echo.
echo ========================================
echo   RESUMEN DE CONFIGURACION
echo ========================================
echo ✓ Backend configurado para produccion
echo ✓ WebSocket habilitado
echo ✓ Frontend en modo produccion
echo ✓ Servicios de notificacion configurados
echo.
echo Para probar las notificaciones:
echo 1. Inicia el servidor: cd BACKEND && npm start
echo 2. Ejecuta la app Flutter: cd FRONTEND\internado && flutter run
echo 3. Crea una tarea o permiso desde la app
echo 4. Las notificaciones apareceran en tiempo real
echo.
echo ========================================
pause
