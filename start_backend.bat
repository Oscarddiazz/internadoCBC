@echo off
title Backend Internado CBC
color 0A

echo.
echo ========================================
echo    BACKEND INTERNADO CBC - INICIANDO
echo ========================================
echo.

cd /d "%~dp0\BACKEND"

echo Verificando dependencias...
if not exist "node_modules" (
    echo Instalando dependencias...
    npm install
    if errorlevel 1 (
        echo Error instalando dependencias
        pause
        exit /b 1
    )
)

echo.
echo Selecciona una opcion:
echo 1. Iniciar en puerto 3000 (por defecto)
echo 2. Iniciar en puerto 8080
echo 3. Iniciar en puerto personalizado
echo 4. Modo desarrollo (nodemon)
echo 5. Ver ayuda
echo 6. Salir
echo.

set /p choice="Ingresa tu opcion (1-6): "

if "%choice%"=="1" (
    echo Iniciando servidor en puerto 3000...
    node start_server.js
) else if "%choice%"=="2" (
    echo Iniciando servidor en puerto 8080...
    node start_server.js --port 8080
) else if "%choice%"=="3" (
    set /p port="Ingresa el puerto: "
    echo Iniciando servidor en puerto %port%...
    node start_server.js --port %port%
) else if "%choice%"=="4" (
    echo Iniciando en modo desarrollo...
    node start_server.js --dev
) else if "%choice%"=="5" (
    node start_server.js --help
    pause
    goto :start
) else if "%choice%"=="6" (
    echo Saliendo...
    exit /b 0
) else (
    echo Opcion invalida
    pause
    goto :start
)

:start
echo.
echo Presiona cualquier tecla para continuar...
pause >nul
goto :start
