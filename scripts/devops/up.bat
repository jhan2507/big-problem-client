@echo off
setlocal
set SCRIPT_DIR=%~dp0
for %%I in ("%SCRIPT_DIR%..\..\docker-compose.yml") do set COMPOSE_FILE=%%~fI
if "%NEXT_PUBLIC_API_BASE_URL%"=="" set NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
docker compose -f "%COMPOSE_FILE%" up -d --build
endlocal
