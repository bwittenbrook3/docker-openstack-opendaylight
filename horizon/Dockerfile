FROM ubuntu:trusty
MAINTAINER Bradley Wittenbrook "bradley.wittenbrook@gmail.com"

# Based off the Intallation Guide located at:
# http://docs.openstack.org/juno/install-guide/install/apt/content/

RUN apt-get -y update && \
	apt-get -y install \
	openstack-dashboard \
	apache2 \
	libapache2-mod-wsgi \
	memcached \
	python-memcache

ADD run.sh run.sh
RUN chmod a+x run.sh
CMD "./run.sh"