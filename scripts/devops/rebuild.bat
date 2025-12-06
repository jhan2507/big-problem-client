@echo off
setlocal
set SCRIPT_DIR=%~dp0
for %%I in ("%SCRIPT_DIR%..\..\docker-compose.yml") do set COMPOSE_FILE=%%~fI
docker compose -f "%COMPOSE_FILE%" build --no-cache
endlocal
