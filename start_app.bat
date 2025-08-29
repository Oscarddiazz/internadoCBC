@echo off
echo ========================================
echo    BioHub - Sistema de Internado CBC
echo ========================================
echo.

echo 🚀 Iniciando servicios...
echo.

echo 📡 Iniciando Backend (API)...
cd BACKEND
start "Backend API" cmd /k "npm start"
cd ..

echo.
echo 📱 Iniciando Frontend (Flutter)...
echo.
echo Opciones disponibles:
echo 1. Emulador Android
echo 2. Web (Chrome)
echo 3. Dispositivo físico conectado
echo.

set /p choice="Selecciona una opción (1-3): "

if "%choice%"=="1" (
    echo 🎯 Iniciando en emulador Android...
    cd FRONTEND\internado
    flutter run
) else if "%choice%"=="2" (
    echo 🌐 Iniciando en web...
    cd FRONTEND\internado
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo 📱 Iniciando en dispositivo físico...
    cd FRONTEND\internado
    flutter devices
    echo.
    echo Selecciona el dispositivo de la lista anterior
    flutter run
) else (
    echo ❌ Opción inválida
    pause
    exit /b 1
)

echo.
echo ✅ Servicios iniciados correctamente
echo.
echo 📊 URLs importantes:
echo    Backend API: http://localhost:3000
echo    Estado API: http://localhost:3000/health
echo    Documentación: http://localhost:3000
echo.
echo 🔧 Para detener los servicios, cierra las ventanas de terminal
pause
