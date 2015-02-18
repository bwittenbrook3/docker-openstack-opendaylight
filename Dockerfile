
FROM ubuntu:trusty
MAINTAINER Bradley Wittenbrook "bradley.wittenbrook@gmail.com"

# Based off the Intallation Guide located at:
# http://docs.openstack.org/juno/install-guide/install/apt/content/

#############################################
## 2. Basic Operating System Configuration ##
#############################################

# Passwords
ENV RABBIT_PASS password
ENV KEYSTONE_DBPASS password
ENV DEMO_PASS demo 
ENV ADMIN_PASS admin 
ENV GLANCE_DBPASS password
ENV GLANCE_PASS password
ENV NOVA_DBPASS password
ENV NOVA_PASS password
ENV DASH_DBPASS password
ENV CINDER_DBPASS password
ENV CINDER_PASS password
ENV NEUTRON_DBPASS password
ENV NEUTRON_PASS password
ENV HEAT_DBPASS password
ENV HEAT_PASS password
ENV CEILOMETER_DBPASS password
ENV CEILOMETER_PASS password
ENV TROVE_DBPASS password
ENV TROVE_PASS password

# Enable the OpenStack Repo
RUN apt-get -y update && \
	apt-get -y install ubuntu-cloud-keyring && \
	echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
  	"trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list

# Finalize the installation
RUN apt-get -y update && \
	apt-get -y dist-upgrade

# Configure the Databse
RUN apt-get -y install \
	mariadb-server \
	python-mysqldb 
RUN service mysql restart

# Install RabbitMQ
RUN apt-get -y install rabbitmq-server && \
	service rabbitmq-server start && \
	rabbitmqctl change_password guest $RABBIT_PASS

