#!/usr/bin/env bash
. /lib/lsb/init-functions

sed -i "s/#ServerName www.example.com/ServerName localhost/g" /etc/apache2/sites-enabled/000-default.conf 


service memcached restart

source /etc/apache2/envvars
cat /etc/hosts
exec /usr/sbin/apache2 -DFOREGROUND
