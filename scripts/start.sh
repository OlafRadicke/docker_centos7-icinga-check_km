ICINGA2_USER=icinga
ICINGA2_GROUP=icingacmd
ICINGA2_CONFIG_FILE=/etc/icinga2/icinga.cfg
ICINGA2_ERROR_LOG=/var/log/icinga2/error.log

/usr/sbin/icinga2 -d -e $ICINGA2_ERROR_LOG -u $ICINGA2_USER  -g $ICINGA2_GROUP $ICINGA2_CONFIG_FILE && echo icinga is started...
