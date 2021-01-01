docker build -t dcjulian29/nagios:4.4.6 .
docker push dcjulian29/nagios
docker tag dcjulian29/nagios:4.4.6 dcjulian29/nagios:latest
docker push dcjulian29/nagios
