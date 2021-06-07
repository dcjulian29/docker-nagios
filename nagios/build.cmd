@echo off
setlocal
set VERSION=4.4.6

docker build --pull --no-cache --progress plain -t dcjulian29/nagios:%VERSION% .
docker tag dcjulian29/nagios:%VERSION%  dcjulian29/nagios:latest

docker push dcjulian29/nagios --all-tags
