FROM debian:11-slim

ARG NAGIOS_VERSION=4.4.6
ARG NRPE_VERSION=4.0.3
ARG PLUGIN_VERSION=2.3.3

ENV TZ                  UTC \
    NAGIOS_PASSWORD     nagios- \
    APACHE_LOG_DIR      /opt/nagios/var

#6
RUN echo 'deb http://deb.debian.org/debian bullseye main contrib non-free' > /etc/apt/sources.list \
 && echo 'deb http://security.debian.org/debian-security bullseye-security main contrib non-free' >> /etc/apt/sources.list \
 && echo 'deb http://deb.debian.org/debian bullseye-updates main contrib non-free' >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y git ca-certificates \
                    snmp snmp-mibs-downloader apache2 libssl-dev libkrb5-dev \
                    libgd-dev libmcrypt-dev libmariadb-dev-compat libmariadb-dev \
                    libnet-snmp-perl default-libmysqlclient-dev libmonitoring-plugin-perl \
                    bc gawk dc libc6 apache2-utils gettext iputils-ping \
                    php apache2-utils gettext iputils-ping python3 \
                    libdata-validate-ip-perl libdata-validate-domain-perl libnet-dns-perl libreadonly-perl \
 && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade

#7
RUN cd /tmp \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf build-essential wget unzip \
 && wget "https://assets.nagios.com/downloads/nagioscore/releases/nagios-${NAGIOS_VERSION}.tar.gz" \
 && tar xzvf nagios-${NAGIOS_VERSION}.tar.gz \
 && cd nagios-* \
 && ./configure --prefix=/opt/nagios --with-httpd-conf=/etc/apache2/sites-enabled \
 && make all \
 && make install-groups-users \
 && usermod -a -G nagios www-data \
 && make install \
 && make install-commandmode \
 && make install-config \
 && make install-webconf \
 && a2enmod rewrite \
 && a2enmod cgi \
 && cd /tmp \
 && wget "https://github.com/NagiosEnterprises/nrpe/archive/nrpe-${NRPE_VERSION}.tar.gz" \
 && tar xzvf nrpe-${NRPE_VERSION}.tar.gz \
 && cd nrpe-nrpe-* \
 && ./configure  --prefix=/opt/nagios --enable-command-args \
 && make all \
 && make install \
 && cd /tmp \
 && wget "https://nagios-plugins.org/download/nagios-plugins-${PLUGIN_VERSION}.tar.gz" \
 && tar xzvf nagios-plugins-${PLUGIN_VERSION}.tar.gz \
 && cd nagios-plugins-* \
 && ./configure --prefix=/opt/nagios \
 && make \
 && make install \
 && make clean \
 && mkdir -p /usr/lib/nagios/plugins \
 && ln -sf /usr/local/nagios/libexec/utils.pm /usr/lib/nagios/plugins \
 && mkdir -p -m 0755 /usr/share/snmp/mibs \
 && touch /usr/share/snmp/mibs/.foo \
 && ln -s /usr/share/snmp/mibs /opt/nagios/libexec/mibs \
 && /usr/bin/download-mibs && echo "mibs +ALL" > /etc/snmp/snmp.conf \
 && rm -Rf /tmp/* /var/tmp/* \
 && rm -Rf /var/www/html \
 && sed -i \
         -e "s|^ServerSignature On|ServerSignature Off|" \
         -e "s|^ServerTokens OS|ServerTokens Prod|" /etc/apache2/conf-enabled/security.conf \
 && sed -i \
        -e "s|ErrorLog ${APACHE_LOG_DIR}/|ErrorLog /opt/nagios/var/|" \
        -e "s|CustomLog ${APACHE_LOG_DIR}/|CustomLog /opt/nagios/var/|" \
        /etc/apache2/sites-enabled/000-default.conf \
 && apt-get purge -y autoconf build-essential wget unzip \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

#8
RUN cd /opt && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y make \
 && git clone https://github.com/harisekhon/nagios-plugins nagios-plugins-hk \
 && cd nagios-plugins-hk \
 && git submodule update --init --recursive \
 && make \
 && make deep-clean \
 && make apt-packages-remove \
 && rm -Rf /tmp/* /var/tmp/* \
 && apt-get purge -y make \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

#9
RUN cd /tmp && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential python3-pip \
 && git clone https://github.com/matteocorti/check_rbl.git \
 && cd check_rbl \
 && perl Makefile.PL INSTALLSITESCRIPT=/opt/nagios/libexec/ \
 && make \
 && make install \
 && cd /opt \
 && pip3 install pymssql \
 && pip3 install check_docker \
 && git clone https://github.com/willixix/naglio-plugins.git nagios-plugins-wl \
 && git clone https://github.com/JasonRivers/nagios-plugins.git nagios-plugins-jr \
 && git clone https://github.com/justintime/nagios-plugins.git nagios-plugins-je \
 && git clone https://github.com/nagiosenterprises/check_mssql_collection.git nagios-plugins-mssql \
 && git clone https://github.com/colebrooke/kubernetes-nagios.git nagios-plugins-kubernetes \
 && chmod +x /opt/nagios-plugins-wl/check* \
 && chmod +x /opt/nagios-plugins-je/check_mem/check_mem.pl \
 && rm -Rf /tmp/* /var/tmp/* \
 && apt-get purge -y build-essential python3-pip \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./slack_nagios.pl /usr/local/bin/slack_nagios.pl
COPY ./index.html /var/www/html/index.html

EXPOSE 80

VOLUME [ "/opt/nagios/etc" ]
VOLUME [ "/opt/nagios/var" ]

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
