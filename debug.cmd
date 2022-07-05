::@echo off
setlocal

set CONTAINER_NAME="docker-nagios-nagios-1"

for /f "delims=" %%x in ('docker.exe ps -qa -f "name=%CONTAINER_NAME%"') do set CONTAINER_EXIST=%%x

echo ***%CONTAINER_EXIST%

if "%CONTAINER_EXIST%"=="" (
    docker run --rm -d --name %CONTAINER_NAME% dcjulian29/nagios
) else (
  for /f "delims=" %%x in ('docker.exe ps -q -f "name=%CONTAINER_NAME%"') do set CONTAINER_RUNNING=%%x

  echo ***%CONTAINER_RUNNING%

  if "%CONTAINER_RUNNING%"=="" (
    docker start %CONTAINER_NAME%
  )
)

docker exec -it %CONTAINER_NAME% bash

docker stop %CONTAINER_NAME%

endlocal
