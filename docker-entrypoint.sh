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

# Remap the nagios account to NAGIOS_UID / NAGIOS_GID when they are set, so
# files on mounted volumes belong to an id chosen on the host instead of
# whatever ids the build happened to give the account. Unset, the image's ids
# are kept. var/ is chowned below; nothing else in the image is re-owned:
# Nagios only writes to var/ and /tmp, and every file the image gives the
# account is world-readable.
remap_nagios_ids() {
  if [ -n "${NAGIOS_GID}" ] && [ "${NAGIOS_GID}" != "$(getent group nagios | cut -d: -f3)" ]; then
    groupmod -o -g "${NAGIOS_GID}" nagios
  fi

  if [ -n "${NAGIOS_UID}" ] && [ "${NAGIOS_UID}" != "$(id -u nagios)" ]; then
    usermod -o -u "${NAGIOS_UID}" nagios
  fi
}

remap_nagios_ids

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
      for env_var in $(printenv | cut -f1 -d"=")
      do
        env_secret_expand $env_var
      done

      if [ ! -f /usr/local/nagios/etc/htpasswd.users ]; then
        touch /usr/local/nagios/etc/htpasswd.users
        chown nagios:www-data /usr/local/nagios/etc/htpasswd.users

        if [ -z $NAGIOS_NAME ]; then
          export NAGIOS_NAME=nagiosadmin
        fi

        if [ -z $NAGIOS_PASSWORD ]; then
          export NAGIOS_PASSWORD=admin
        fi

        htpasswd -bB /usr/local/nagios/etc/htpasswd.users $NAGIOS_NAME $NAGIOS_PASSWORD
      else
        chown nagios:www-data /usr/local/nagios/etc/htpasswd.users
      fi

      if [ -f /run/apache2/apache2.pid ]; then
        rm -f /run/apache2/apache2.pid
      fi

      if [ -f /run/nagios.lock ]; then
        rm -f /run/nagios.lock
      fi

      /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
    fi
    ;;
esac
