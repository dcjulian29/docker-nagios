#!/bin/bash

: ${SECRET_DIR:=/run/secrets}

# XYZ_DB_PASSWORD={{DOCKER-SECRET:my-db.secret}}
env_secret_expand() {
  var="$1"
  eval val=\$$var

  if secret_name=$(expr match "$val" "{{DOCKER-SECRET:\([^}]\+\)}}$"); then
    secret="${SECRET_DIR}/${secret_name}"
    if [ -f "$secret" ]; then
      val=$(cat "${secret}")
      export "$var"="$val"
    fi
  fi
}

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

    chown -R nagios:nagios /usr/local/nagios/var

    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

    if [ $? -eq 0 ]; then
      if [ ! -d /usr/local/nagios/etc/htpasswd.users ]; then
        touch /usr/local/nagios/etc/htpasswd.users
        chown nagios:www-data /usr/local/nagios/etc/htpasswd.users
      fi

      for env_var in $(printenv | cut -f1 -d"=")
      do
        env_secret_expand $env_var
      done

      if [ -z $NAGIOS_NAME ]; then
        export NAGIOS_NAME=nagiosadmin
      fi

      if [ -z $NAGIOS_PASSWORD ]; then
        export NAGIOS_PASSWORD=admin
      fi

      htpasswd -bB /usr/local/nagios/etc/htpasswd.users $NAGIOS_NAME $NAGIOS_PASSWORD

      /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
    fi
    ;;
esac
