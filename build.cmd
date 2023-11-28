@echo off
setlocal

pushd %~dp0

for /f "delims=" %%x in (VERSION) do set NAGIOSVERSION=%%x
for /f "delims=" %%x in (VERSION_NRPE) do set NRPEVERSION=%%x
for /f "delims=" %%x in (VERSION_PLUGIN) do set PLUGINVERSION=%%x

echo.
echo *
echo * Nagios Version: %NAGIOSVERSION%
echo * NRPE Version: %NRPEVERSION%
echo *
echo.

docker build --no-cache --progress plain --pull --tag dcjulian29/nagios:%NAGIOSVERSION% ^
  --build-arg NAGIOS_VERSION=%NAGIOSVERSION% --build-arg NRPE_VERSION=%NRPEVERSION% ^
  --build-arg PLUGIN_VERSION=%PLUGINVERSION% .

if %errorlevel% neq 0 goto FINAL

docker tag dcjulian29/nagios:%NAGIOSVERSION%  dcjulian29/nagios:latest
docker image inspect dcjulian29/nagios:%NAGIOSVERSION% > .docker\nagios_%NAGIOSVERSION%.json

echo.
echo *
echo * Plugins Version: %PLUGINVERSION%
echo *
echo.

docker build --tag dcjulian29/nagios:%NAGIOSVERSION%-plugins ^
  --build-arg NAGIOS_VERSION=%NAGIOSVERSION% plugins/.

if %errorlevel% neq 0 goto FINAL

docker tag dcjulian29/nagios:%NAGIOSVERSION%-plugins dcjulian29/nagios:latest-plugins
docker image inspect dcjulian29/nagios:%NAGIOSVERSION%-plugins > .docker\nagios_%NAGIOSVERSION%-plugins.json

:FINAL

popd

endlocal
