@echo off
setlocal
set CMD=%1
set SCRIPT_DIR=%~dp0
for %%I in ("%SCRIPT_DIR%..\..\docker-compose.yml") do set COMPOSE_FILE=%%~fI

if /I "%CMD%"=="up" (
  if "%NEXT_PUBLIC_API_BASE_URL%"=="" set NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
  docker compose -f "%COMPOSE_FILE%" up -d --build
  goto :eof
)
if /I "%CMD%"=="down" (
  docker compose -f "%COMPOSE_FILE%" down
  goto :eof
)
if /I "%CMD%"=="rebuild" (
  docker compose -f "%COMPOSE_FILE%" build --no-cache
  goto :eof
)
echo Usage: %~nx0 ^<up^|down^|rebuild^>
endlocal
