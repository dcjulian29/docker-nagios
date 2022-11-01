# A Docker Container for Nagios

[![GitHub Issues](https://img.shields.io/github/issues-raw/dcjulian29/docker-nagios.svg)](https://github.com/dcjulian29/docker-nagios/issues) [![CI](https://github.com/dcjulian29/docker-nagios/actions/workflows/ci.yml/badge.svg)](https://github.com/dcjulian29/docker-nagios/actions/workflows/ci.yml) [![Release](https://github.com/dcjulian29/docker-nagios/actions/workflows/release.yml/badge.svg)](https://github.com/dcjulian29/docker-nagios/actions/workflows/release.yml) [![Version](https://img.shields.io/docker/v/dcjulian29/nagios?sort=semver)](https://hub.docker.com/repository/docker/dcjulian29/nagios) [![Docker Pulls](https://img.shields.io/docker/pulls/dcjulian29/nagios.svg)](https://hub.docker.com/r/dcjulian29/nagios/)


This is a docker container that I use to deploy nagios to various environments for monitoring. Sometimes it is for whole network monitoring and sometimes it is simple inter-cluster application monitoring.

This image currently is a monolithic image containing all of the plugins/checks for all environment. Possibly plan to update to a base image with additional images specialized to more specific environments... any suggestions are welcome.
