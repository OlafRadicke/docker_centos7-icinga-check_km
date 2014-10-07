# DOCKER-VERSION 0.3.4
# image olafradicke/centos7-icinga-check_km

FROM centos:centos7
MAINTAINER Olaf Raicke <olaf@atix.de>

ENV ICINGA_USER icinga
ENV ICINGA_PW icinga
ENV ICINGA_CMD icinga-cmd
ENV BUILD_DIR /tmp/

RUN yum -y update
RUN yum -y install wget tar gzip
RUN yum -y install httpd gcc glibc glibc-common gd gd-devel
RUN yum -y install libjpeg libjpeg-devel libpng libpng-devel
RUN yum -y install net-snmp net-snmp-devel net-snmp-utils

RUN  /usr/sbin/useradd -m icinga
RUN  echo "$ICINGA_USER:$ICINGA_PW"|chpasswd

RUN /usr/sbin/groupadd icinga-cmd
RUN /usr/sbin/usermod -a -G icinga-cmd icinga
RUN /usr/sbin/usermod -a -G icinga-cmd apache

# icinga
WORKDIR  $BUILD_DIR
RUM wget https://github.com/Icinga/icinga2/archive/v2.1.1.tar.gz
RUN ls -lah
RUN tar -xzf  v2.1.1.tar.gz
RUN ls -lah
WORKDIR  $BUILD_DIR/icinga2-2.1.1/
RUN ./configure --with-command-group=$ICINGA_CMD --disable-idoutils
RUN make all
RUN make install
# CentOS 7 has systemd
# RUN make install-init
RUN make install-config
RUN make install-eventhandlers
RUN make install-commandmode
WORKDIR  $BUILD_DIR
RUN rm -Rvf ./v2.1.1.tar.gz ./icinga2-2.1.1/

# plugins
WORKDIR  $BUILD_DIR
RUM wget https://www.monitoring-plugins.org/download/monitoring-plugins-2.0.tar.gz
RUN ls -lah
RUN tar -xzf ./monitoring-plugins-2.0.tar.gz
RUN ls -lah
WORKDIR  $BUILD_DIR/nagios-plugins-2.0
RUN ./configure --prefix=/usr/local/icinga --with-cgiurl=/icinga/cgi-bin --with-nagios-user=icinga --with-nagios-group=icinga
RUN make
RUN make install
WORKDIR  $BUILD_DIR
RUN rm -Rvf ./monitoring-plugins-2.0.tar.gz ./nagios-plugins-2.0

RUN setenforce 0
RUN chkconfig --add icinga
RUN chkconfig icinga on
# RUN service icinga start

# check_mk
RUN  yum -y install --nogpgcheck  https://mathias-kettner.de/download/check_mk-agent-1.2.4p5-1.noarch.rpm


CMD ["service", "icinga start"]
EXPOSE 22



VOLUME ["/var/docker/cxxtools/workspace/"]
