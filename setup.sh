#!/usr/bin/env bash
service mysql start
service rabbitmq-server start 

. /lib/lsb/init-functions

# Configure Identity Service 
log_daemon_msg "Configuring Identity Service"
mysql -u root -Bse "CREATE DATABASE keystone;"
mysql -u root -Bse "GRANT ALL PRIVILEGES ON keystone.* \
	TO 'keystone'@'localhost' \
  	IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -u root -Bse "GRANT ALL PRIVILEGES ON keystone.* \
	TO 'keystone'@'%' \
  	IDENTIFIED BY '$KEYSTONE_DBPASS';"
log_end_msg 0


