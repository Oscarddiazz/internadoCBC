@echo off
title Backend Internado CBC
color 0A

echo.
echo ========================================
echo    BACKEND INTERNADO CBC
echo ========================================
echo.

cd /d "%~dp0\BACKEND"

echo Iniciando servidor...
echo Puerto: 3000
echo Web: http://localhost:3000
echo Android: http://10.0.2.2:3000
echo.

node server.js

pause
