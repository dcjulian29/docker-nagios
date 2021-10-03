#!/bin/bash

case $@ in
  shell)
    /bin/bash
    ;;

  validate)
    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
    ;;

  *)
    if [ ! -d /usr/local/nagios/var/archives ]; then
      mkdir /usr/local/nagios/var/archives
    fi

    if [ ! -d /usr/local/nagios/var/rw ]; then
      mkdir /usr/local/nagios/var/rw
    fi

    if [ ! -d /usr/local/nagios/var/spool ]; then
      mkdir /usr/local/nagios/var/spool
    fi

    if [ ! -d /usr/local/nagios/var/spool/checkresults ]; then
      mkdir /usr/local/nagios/var/spool/checkresults
    fi

    if [ ! -d /usr/local/nagios/var/apache2 ]; then
      mkdir /usr/local/nagios/var/apache2
    fi

    chown -R nagios:nagios /usr/local/nagios/var
    chown -R nagios:www-data /usr/local/nagios/var/apache2

    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

    if [ $? -eq 0 ]; then
      if [ ! -d /usr/local/nagios/etc/htpasswd.users ]; then
        touch /usr/local/nagios/etc/htpasswd.users
        chown nagios:www-data /usr/local/nagios/etc/htpasswd.users
      fi

      htpasswd -bB /usr/local/nagios/etc/htpasswd.users nagiosadmin $NAGIOS_PASSWORD
      apachectl -k start
      /usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg
      tail -f /usr/local/nagios/var/nagios.log
    fi
    ;;
esac
