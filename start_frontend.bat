@echo off
title Frontend Internado CBC
color 0A

echo.
echo ========================================
echo    FRONTEND INTERNADO CBC
echo ========================================
echo.

cd /d "%~dp0\FRONTEND\internado"

echo Verificando dependencias...
flutter pub get

echo.
echo Selecciona una opcion:
echo 1. Ejecutar en Web
echo 2. Ejecutar en Android
echo 3. Ejecutar en iOS
echo 4. Salir
echo.

set /p choice="Ingresa tu opcion (1-4): "

if "%choice%"=="1" (
    echo Ejecutando en Web...
    flutter run -d chrome
) else if "%choice%"=="2" (
    echo Ejecutando en Android...
    flutter run
) else if "%choice%"=="3" (
    echo Ejecutando en iOS...
    flutter run -d ios
) else if "%choice%"=="4" (
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
