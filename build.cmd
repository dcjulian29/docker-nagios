@echo off
setlocal

pushd %~dp0

for /f "delims=" %%x in (VERSION) do set NAGIOSVERSION=%%x
for /f "delims=" %%x in (VERSION_NPRE) do set NPREVERSION=%%x
for /f "delims=" %%x in (VERSION_PLUGIN) do set PLUGINVERSION=%%x

echo --------------------------------------------------------------------------
echo Nagios Version: %NAGIOSVERSION%
echo NPRE Version: %NPREVERSION%
echo Plugins Version: %PLUGINVERSION%
echo --------------------------------------------------------------------------

docker build --progress plain -t dcjulian29/nagios:%NAGIOSVERSION% . ^
  --build-arg NAGIOS_VERSION=%NAGIOSVERSION% --build-arg NPRE_VERSON=%NPREVERSON% ^
  --build-arg PLUGIN_VERSION=%PLUGINVERSION%

if ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

popd

docker tag dcjulian29/nagios:%NAGIOSVERSION%  dcjulian29/nagios:latest
