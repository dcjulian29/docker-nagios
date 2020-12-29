#!/bin/bash

case $@ in
  shell)
    /bin/bash
    ;;

  validate)
    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
    ;;

  *)
    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

    if [ $? -eq 0 ]; then
        htpasswd -b /usr/local/nagios/etc/htpasswd.users nagiosadmin $NAGIOS_PASSWORD
        apachectl -k start
        /usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg
        tail -f /var/log/apache2/access.log /var/log/apache2/error.log /usr/local/nagios/var/nagios.log
    fi
    ;;
esac
