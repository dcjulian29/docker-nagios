FROM debian:13-slim

ARG NAGIOS_VERSION
ARG NRPE_VERSION
ARG PLUGIN_VERSION

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod 0755 /docker-entrypoint.sh \
  && apt-get update \
  && apt-get install -y apache2 apache2-utils \
  && apt-get install -y php openssl supervisor iputils-ping \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

RUN apt-get update \
  && apt-get install -y autoconf gcc libc6 make wget unzip libgd-dev libssl-dev \
  && cd /tmp \
  && wget "https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-${NAGIOS_VERSION}/nagios-${NAGIOS_VERSION}.tar.gz" \
  && tar xzvf nagios-${NAGIOS_VERSION}.tar.gz \
  && cd nagios-${NAGIOS_VERSION} \
  && ./configure --prefix=/usr/local/nagios --with-httpd-conf=/etc/apache2/sites-enabled \
  && make all \
  && make install-groups-users \
  && usermod -a -G nagios www-data \
  && make install \
  && make install-commandmode \
  && make install-config \
  && make install-webconf \
  && a2enmod rewrite \
  && a2enmod cgi \
  && rm -Rf /tmp/* /var/tmp/* \
  && apt-get purge -y autoconf gcc make wget unzip \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

RUN apt-get update \
  && apt-get install -y autoconf gcc make wget libmcrypt-dev bc gawk dc \
     build-essential snmp libnet-snmp-perl libwww-perl gettext smistrip patch \
  && rm -f /usr/lib/python3.11/EXTERNALLY-MANAGED \
  && rm -f /usr/lib/python3.12/EXTERNALLY-MANAGED \
  && cd /tmp \
  && wget "https://github.com/NagiosEnterprises/nrpe/archive/nrpe-${NRPE_VERSION}.tar.gz" \
  && tar xzvf nrpe-${NRPE_VERSION}.tar.gz \
  && cd nrpe-nrpe-* \
  && ./configure  --prefix=/usr/local/nagios --enable-command-args \
  && make all \
  && make install \
  && wget "https://github.com/nagios-plugins/nagios-plugins/archive/release-${PLUGIN_VERSION}.tar.gz" \
  && tar xzvf release-${PLUGIN_VERSION}.tar.gz \
  && cd nagios-plugins-release-${PLUGIN_VERSION} \
  && ./tools/setup \
  && ./configure --prefix=/usr/local/nagios \
  && make \
  && make install \
  && make clean \
  && mkdir -p /usr/lib/nagios/plugins \
  && ln -sf /usr/local/nagios/libexec/utils.pm /usr/lib/nagios/plugins \
  && mkdir -p -m 0755 /usr/share/snmp/mibs \
  && touch /usr/share/snmp/mibs/.foo \
  && ln -s /usr/share/snmp/mibs /usr/local/nagios/libexec/mibs \
  && wget http://http.us.debian.org/debian/pool/non-free/s/snmp-mibs-downloader/snmp-mibs-downloader_1.5_all.deb \
  && dpkg -i snmp-mibs-downloader_1.5_all.deb \
  && /usr/bin/download-mibs && echo "mibs +ALL" > /etc/snmp/snmp.conf \
  && rm -Rf /tmp/* /var/tmp/* \
  && rm -Rf /var/www/html \
  && sed -i \
         -e "s|^ServerSignature On|ServerSignature Off|" \
         -e "s|^ServerTokens OS|ServerTokens Prod|" /etc/apache2/conf-enabled/security.conf \
  && echo "ServerName nagios" > /etc/apache2/conf-enabled/servername.conf \
  && apt-get purge -y autoconf gcc make wget build-essential smistrip patch snmp-mibs-downloader \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

COPY ./index.html /var/www/html/index.html
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

VOLUME [ "/usr/local/nagios/etc" ]
VOLUME [ "/usr/local/nagios/var" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
