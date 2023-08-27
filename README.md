# A Docker Container for Nagios

[![GitHub Issues](https://img.shields.io/github/issues-raw/dcjulian29/docker-nagios.svg)](https://github.com/dcjulian29/docker-nagios/issues) [![CI](https://github.com/dcjulian29/docker-nagios/actions/workflows/ci.yml/badge.svg)](https://github.com/dcjulian29/docker-nagios/actions/workflows/ci.yml) [![Release](https://github.com/dcjulian29/docker-nagios/actions/workflows/release.yml/badge.svg)](https://github.com/dcjulian29/docker-nagios/actions/workflows/release.yml) [![Version](https://img.shields.io/docker/v/dcjulian29/nagios?sort=semver)](https://hub.docker.com/repository/docker/dcjulian29/nagios) [![Docker Pulls](https://img.shields.io/docker/pulls/dcjulian29/nagios.svg)](https://hub.docker.com/r/dcjulian29/nagios/)

Nagios is a host/service/network monitoring program written in C and released under the GNU General Public License, version 2. CGI programs are included to allow you to view the current status, history, etc via a web interface if you so desire.

Visit the Nagios homepage at <https://www.nagios.org> for documentation, new releases, bug reports, information on discussion forums, and more.

This project consist of a set of docker containers that I use to deploy nagios to various environments for monitoring. Sometimes it is for whole network monitoring and sometimes it is simple inter-cluster application monitoring.

The base image currently is utilizing a monolithic style containing all of the plugins/checks for most environments. Currently, one additional image exist with additional plug-ins.

Possibly plan to update to a base image with additional images specialized to more specific environments... any suggestions are welcome.

## Latest Upstream Versions

* ![Nagios](https://img.shields.io/github/v/release/NagiosEnterprises/nagioscore?label=Nagios%20Core)
* ![NRPE](https://img.shields.io/github/v/release/NagiosEnterprises/nrpe?label=NRPE)
* ![Plugins](https://img.shields.io/github/v/release/nagios-plugins/nagios-plugins?label=Nagios%20Plugins)
