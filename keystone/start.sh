#!/usr/bin/env bash
. /lib/lsb/init-functions

# Configure Keystone
log_daemon_msg "Configuring Keystone"
export ADMIN_TOKEN=$(openssl rand -hex 10)
export OS_SERVICE_TOKEN=$ADMIN_TOKEN
export OS_SERVICE_ENDPOINT=http://localhost:35357/v2.0
export OS_AUTH_URL=http://localhost:35357/v2.0

sed -i "s/#admin_token=ADMIN/admin_token=$ADMIN_TOKEN/g" /etc/keystone/keystone.conf
sed -i "s/connection=sqlite\:\/\/\/\/var\/lib\/keystone\/keystone.db/connection=mysql\:\/\/root:$MYSQL_ROOT_PASSWORD@mysql\/keystone/g" /etc/keystone/keystone.conf
sed -i "s/#provider=<None>/provider=keystone.token.providers.uuid.Provider/g" /etc/keystone/keystone.conf
sed -i "s/#driver=keystone.token.persistence.backends.sql.Token/driver=keystone.token.persistence.backends.sql.Token/g" /etc/keystone/keystone.conf
sed -i "s/#driver=keystone.contrib.revoke.backends.kvs.Revoke/driver=keystone.contrib.revoke.backends.sql.Revoke/g" /etc/keystone/keystone.conf

mysql -h mysql --password=password -Bse "CREATE DATABASE keystone;"
mysql -h mysql --password=password -Bse "GRANT ALL PRIVILEGES ON keystone.* \
	TO 'keystone'@'localhost' \
  	IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mysql -h mysql --password=password -Bse "GRANT ALL PRIVILEGES ON keystone.* \
	TO 'keystone'@'%' \
  	IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

# Populate the Identity service databse
su -s /bin/sh -c "keystone-manage db_sync" keystone
log_end_msg 0

# Finialize the installation
log_daemon_msg "Starting up Keystone Service"
rm -f /var/lib/keystone/keystone.db

# Purge Expired tokens hourly
(crontab -l -u keystone 2>&1 | grep -q token_flush) || \
  echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' \
  >> /var/spool/cron/crontabs/keystone

# Start the Keystone Service
keystone-all &
log_end_msg 0
wait 10
keystone discover
