FROM ubuntu:trusty
MAINTAINER Bradley Wittenbrook "bradley.wittenbrook@gmail.com"

# Based off the Intallation Guide located at:
# http://docs.openstack.org/juno/install-guide/install/apt/content/

RUN apt-get -y update && \
	apt-get -y install \
	mariadb-server \
	keystone \
	python-keystoneclient

# Add Startup File
ADD start.sh start.sh
RUN chmod a+x start.sh
CMD bash -C "start.sh"