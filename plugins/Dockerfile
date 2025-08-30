ARG NAGIOS_VERSION

FROM dcjulian29/nagios:${NAGIOS_VERSION}

COPY ./slack_nagios.pl /usr/local/bin/slack_nagios.pl

RUN chmod 755 /usr/local/bin/slack_nagios.pl \
  && cd /usr/local && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential python3-pip git wget \
  && apt-get install -y libmodule-install-perl python3-mysqldb libmariadb-dev-compat python3-kerberos \
  && git clone https://github.com/harisekhon/nagios-plugins nagios-plugins-hk \
  && cd nagios-plugins-hk \
  && git submodule update --init --recursive \
  && (cpan -P -T $(sed 's/#.*//' setup/cpan-requirements*.txt lib/setup/cpan-requirements*.txt) || true) \
  && apt-get purge -y build-essential python3-pip git  \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove \
  && rm -Rf /root/.cpan /tmp/* /var/tmp/* \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && chown -R nagios:nagios /usr/local/nagios-plugins-hk

RUN cd /tmp && apt-get update \
  && apt-get install -y build-essential python3-pip git libmodule-install-perl libjson-perl wget \
  && git clone https://github.com/matteocorti/check_rbl.git \
  && cd check_rbl \
  && perl Makefile.PL INSTALLSITESCRIPT=/usr/local/nagios/libexec/ \
  && make \
  && make install \
  && cd /usr/local \
  && python3 -m pip config set global.break-system-packages true \
  && pip3 install pymssql \
  && pip3 install check_docker \
  && git clone https://github.com/willixix/naglio-plugins.git nagios-plugins-wl \
  && git clone https://github.com/JasonRivers/nagios-plugins.git nagios-plugins-jr \
  && git clone https://github.com/justintime/nagios-plugins.git nagios-plugins-je \
  && git clone https://github.com/nagiosenterprises/check_mssql_collection.git nagios-plugins-mssql \
  && git clone https://github.com/colebrooke/kubernetes-nagios.git nagios-plugins-kubernetes \
  && chmod +x /usr/local/nagios-plugins-wl/check* \
  && chmod +x /usr/local/nagios-plugins-je/check_mem/check_mem.pl \
  && cd /tmp \
  && wget https://github.com/chriscareycode/nagiostv-react/releases/download/v0.8.5/nagiostv-0.8.5.tar.gz \
  && tar xzvf nagiostv-0.8.5.tar.gz \
  && mv nagiostv /usr/local/nagios/share/ \
  && rm -Rf /tmp/* /var/tmp/* \
  && apt-get purge -y build-essential python3-pip git libmodule-install-perl wget \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && chown -R nagios:nagios /usr/local/nagio*
