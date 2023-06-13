@echo off
setlocal

set CONTAINER_NAME="nagios-nagios-1"

for /f "delims=" %%x in ('docker.exe ps -qa -f "name=%CONTAINER_NAME%"') do set CONTAINER_EXIST=%%x

if "%CONTAINER_EXIST%"=="" (
  docker compose up -d
) else (
  for /f "delims=" %%x in ('docker.exe ps -q -f "name=%CONTAINER_NAME%"') do set CONTAINER_RUNNING=%%x

  if "%CONTAINER_RUNNING%"=="" (
    docker start %CONTAINER_NAME%
  )
)

docker exec -it %CONTAINER_NAME% bash

endlocal
