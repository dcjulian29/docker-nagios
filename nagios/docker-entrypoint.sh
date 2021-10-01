#!/bin/bash

case $@ in
  shell)
    /bin/bash
    ;;

  validate)
    /opt/nagios/bin/nagios -v /opt/nagios/etc/nagios.cfg
    ;;

  *)
    /opt/nagios/bin/nagios -v /opt/nagios/etc/nagios.cfg

    if [ $? -eq 0 ]; then
        htpasswd -b /opt/nagios/etc/htpasswd.users nagiosadmin $NAGIOS_PASSWORD
        apachectl -k start
        /opt/nagios/bin/nagios -d /opt/nagios/etc/nagios.cfg
        tail -f /opt/nagios/var/nagios.log
    fi
    ;;
esac
