#
# (c) 2018 Nélson Rafael Martins All Rights Reserved
#

# Use a specific version to be repeatable
FROM phusion/baseimage

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add a script to run the Mongo daemon
ADD mongod.sh /etc/service/mongod/run

# Add a script to run the a Node app
ADD nodestart.sh /etc/service/nodestart/run

# Install Node.js
RUN apt-get -y update && \
    apt-get -y install wget && \
    apt-get -y install npm && \
	ln -s /usr/bin/nodejs /usr/bin/node && \
    npm install -g n && \
	n stable && \
    npm install -g nodemon && \
	npm install express --save && \
	npm install mongoose --save && \
	npm install body-parser --save && \
	npm install cors --save && \
    mkdir -p /vol/node/start
	
# Set up the default app
ADD api-routes.js index.js linhaController.js linhaModel.js package.json /vol/node/start/

# Install MongoDB v 2.6.11
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
  echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
  apt-get update && \
  apt-get install -y mongodb-org && \
  mkdir -p /vol/data/db 

# Define mountable directories for mongo and node
VOLUME ["/vol/data/db", "/vol/node/start"]

EXPOSE 27017 28017 8080

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*