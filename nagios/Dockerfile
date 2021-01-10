FROM debian:buster-slim

ENV TZ                  UTC
ENV DEBIAN_FRONTEND     noninteractive
ENV NAGIOS_PASSWORD     nagios
ENV NAGIOS_VERSION      nagios-4.4.6
ENV NRPE_VERSION        nrpe-4.0.3

RUN echo 'deb http://deb.debian.org/debian buster main contrib non-free' > /etc/apt/sources.list \
    && echo 'deb http://security.debian.org/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list \
    && echo 'deb http://deb.debian.org/debian buster-updates main contrib non-free' >> /etc/apt/sources.list \
    && apt update && apt upgrade -y \
    && apt install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php \
                      libgd-dev libmcrypt-dev libssl-dev bc gawk dc build-essential \
                      snmp libnet-snmp-perl snmp-mibs-downloader \
                      gettext curl iputils-ping git python python-pip

RUN cd /tmp \
    && curl -fsSL "https://assets.nagios.com/downloads/nagioscore/releases/${NAGIOS_VERSION}.tar.gz" -o nagios.tgz \
    && tar xzf nagios.tgz \
    && cd nagios-* \
    && ./configure --with-httpd-conf=/etc/apache2/sites-enabled \
    && make all \
    && make install-groups-users \
    && usermod -a -G nagios www-data \
    && make install \
    && make install-commandmode \
    && make install-config \
    && make install-webconf \
    && a2enmod rewrite \
    && a2enmod cgi

RUN cd /tmp \
    && curl -fsSL "https://github.com/NagiosEnterprises/nrpe/archive/${NRPE_VERSION}.tar.gz" -o nrpe.tgz \
    && tar xzf nrpe.tgz \
    && cd nrpe-nrpe-* \
    && ./configure --enable-command-args \
    && make all \
    && make install

RUN mkdir -p -m 0755 /usr/share/snmp/mibs \
    && touch /usr/share/snmp/mibs/.foo \
    && ln -s /usr/share/snmp/mibs /usr/local/nagios/libexec/mibs \
    && /usr/bin/download-mibs && echo "mibs +ALL" > /etc/snmp/snmp.conf

RUN cd /tmp \
    && git clone https://github.com/nagios-plugins/nagios-plugins.git \
    && cd nagios-plugins \
    && ./tools/setup \
    && ./configure \
    && make \
    && make install \
    && make clean \
    && mkdir -p /usr/lib/nagios/plugins \
    && ln -sf /usr/local/nagios/libexec/utils.pm /usr/lib/nagios/plugins

RUN cd /opt \
    && git clone https://github.com/harisekhon/nagios-plugins hansekhon-plugins \
    && cd hansekhon-plugins \
    && make build

RUN apt install -y libmonitoring-plugin-perl \
    && cd /tmp \
    && git clone https://github.com/matteocorti/check_rbl.git \
    && cd check_rbl \
    && perl Makefile.PL \
    && make \
    && make install

RUN cd /opt \
    && pip install pymssql \
    && pip3 install check_docker \
    && git clone https://github.com/willixix/naglio-plugins.git WL-Nagios-Plugins \
    && git clone https://github.com/JasonRivers/nagios-plugins.git JR-Nagios-Plugins \
    && git clone https://github.com/justintime/nagios-plugins.git JE-Nagios-Plugins \
    && git clone https://github.com/nagiosenterprises/check_mssql_collection.git nagios-mssql \
    && git clone https://github.com/colebrooke/kubernetes-nagios.git nagios-kubernetes \
    && chmod +x /opt/WL-Nagios-Plugins/check* \
    && chmod +x /opt/JE-Nagios-Plugins/check_mem/check_mem.pl

RUN rm -Rf /tmp/* /var/tmp/* \
    && rm -Rf /var/www/html \
    && apt-get clean \
    && rm -Rf /var/lib/apt/lists/*

COPY ./start.sh /start.sh
COPY ./slack_nagios.pl /usr/local/bin/slack_nagios.pl
COPY ./index.html /var/www/html/index.html

EXPOSE 80

VOLUME [ "/usr/local/nagios/etc" ]

ENTRYPOINT [ "/start.sh" ]
