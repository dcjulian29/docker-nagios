@echo off
setlocal

set CONTAINER_NAME="docker-nagios-nagios-1"

for /f "delims=" %%x in ('docker.exe ps -qa -f "name=%CONTAINER_NAME%"') do set CONTAINER_EXIST=%%x

if "%CONTAINER_EXIST%"=="" (
    docker run -d --name %CONTAINER_NAME% ^
      -p "8080:80" ^
      -e "TZ=America/New_York" ^
      -e "NAGIOS_PASSWORD=P@ssw0rd!" ^
      -v "%PWD%/../nagios:/usr/local/nagios/etc" ^
      -v "%PWD%/.docker/var:/usr/local/nagios/var" ^
      dcjulian29/nagios
) else (
  for /f "delims=" %%x in ('docker.exe ps -q -f "name=%CONTAINER_NAME%"') do set CONTAINER_RUNNING=%%x

  if "%CONTAINER_RUNNING%"=="" (
    docker start %CONTAINER_NAME%
  )
)

docker exec -it %CONTAINER_NAME% bash

endlocal
