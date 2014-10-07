# DOCKER-VERSION 0.3.4
# image olafradicke/centos7-icinga-check_km

FROM centos:7
MAINTAINER Olaf Raicke <olaf@atix.de>

ENV ICINGA_USER icinga
ENV ICINGA_PW icinga
ENV ICINGA_CMD icinga-cmd

RUN yum -y install wget
RUN yum -y install httpd gcc glibc glibc-common gd gd-devel
RUN yum -y install libjpeg libjpeg-devel libpng libpng-devel
RUN yum -y install net-snmp net-snmp-devel net-snmp-utils

RUN  /usr/sbin/useradd -m icinga
RUN  echo "$ICINGA_USER:$ICINGA_PW"|chpasswd

RUN /usr/sbin/groupadd icinga-cmd
RUN /usr/sbin/usermod -a -G icinga-cmd icinga
RUN /usr/sbin/usermod -a -G icinga-cmd www-data

WORKDIR  /usr/src
RUM wget https://github.com/Icinga/icinga2/archive/v2.1.1.tar.gz
RUN tar -xzf  v2.1.1.tar.gz
RUN ./configure --with-command-group=$ICINGA_CMD --disable-idoutils
RUN make all


RUM wget https://www.monitoring-plugins.org/download/monitoring-plugins-2.0.tar.gz
RUN tar -xzf monitoring-plugins-2.0.tar.gz

WORKDIR  icinga2-2.1.1/



#########################

RUN yum -y install gcc-c++ make wget
RUN yum -y install libtool mysql++-devel sqlite-devel openssl-devel postgresql-devel

WORKDIR /tmp
RUN  wget www.tntnet.org/download/cxxtools-2.2.1.tar.gz
RUN  tar -xzf  cxxtools-2.2.1.tar.gz
WORKDIR /tmp/cxxtools-2.2.1
RUN /usr/bin/ls -lah
RUN  /bin/bash ./configure
RUN  make
RUN  make install

RUN  echo "/usr/local/lib" >  /etc/ld.so.conf.d/cxxtools.conf
RUN  ldconfig
RUN  rm -Rvf /tmp/cxxtools-2.2.1.tar.gz /tmp/cxxtools-2.2.1

VOLUME ["/var/docker/cxxtools/workspace/"]
