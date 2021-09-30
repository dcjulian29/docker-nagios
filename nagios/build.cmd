@echo off
setlocal
set NAGIOSVERSION=4.4.6
set NPREVERSION=4.0.3


echo --------------------------------------------------------------------------
echo Nagios Version: %NAGIOSVERSION%
echo NPRE Version: %NPREVERSION%
echo --------------------------------------------------------------------------

docker build --pull --progress plain -t dcjulian29/nagios:%NAGIOSVERSION% . ^
  --build-arg NAGIOS_VERSION=%NAGIOSVERSION% --build-arg NPRE_VERSON=%NPREVERSON%

docker tag dcjulian29/nagios:%NAGIOSVERSION%  dcjulian29/nagios:latest

if "%1" == "" GOTO :EOF

echo --------------------------------------------------------------------------

docker push dcjulian29/nagios --all-tags
