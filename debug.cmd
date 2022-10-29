@echo off
setlocal

set CONTAINER_NAME="docker-nagios-nagios-1"

for /f "delims=" %%x in ('docker.exe ps -qa -f "name=%CONTAINER_NAME%"') do set CONTAINER_EXIST=%%x

if "%CONTAINER_EXIST%"=="" (
  docker compose up
) else (
  for /f "delims=" %%x in ('docker.exe ps -q -f "name=%CONTAINER_NAME%"') do set CONTAINER_RUNNING=%%x

  if "%CONTAINER_RUNNING%"=="" (
    docker start %CONTAINER_NAME%
  )
)

docker exec -it %CONTAINER_NAME% bash

endlocal
