@echo off
setlocal

pushd %~dp0

for /f "delims=" %%x in (VERSION) do set NAGIOSVERSION=%%x
for /f "delims=" %%x in (VERSION_NRPE) do set NRPEVERSION=%%x
for /f "delims=" %%x in (VERSION_PLUGIN) do set PLUGINVERSION=%%x

echo --------------------------------------------------------------------------
echo Nagios Version: %NAGIOSVERSION%
echo NRPE Version: %NRPEVERSION%
echo Plugins Version: %PLUGINVERSION%
echo --------------------------------------------------------------------------

docker build --tag dcjulian29/nagios:%NAGIOSVERSION% . ^
  --build-arg NAGIOS_VERSION=%NAGIOSVERSION% --build-arg NRPE_VERSION=%NRPEVERSION% ^
  --build-arg PLUGIN_VERSION=%PLUGINVERSION%

if ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

popd

docker tag dcjulian29/nagios:%NAGIOSVERSION%  dcjulian29/nagios:latest
