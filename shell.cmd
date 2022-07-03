@docker run --rm -it ^
  -v "/c/code/nagios:/usr/local/nagios/etc" ^
  -v "/c/code/docker/nagios/.docker/var:/usr/local/nagios/var" ^
  dcjulian29/nagios shell
