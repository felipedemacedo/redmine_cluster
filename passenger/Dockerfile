FROM felipederodrigues/redmine_cluster:latest

ENV PASSENGER_VERSION 5.1.4

RUN buildDeps=' \
		make \
	' \
	&& set -x \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
	&& gem install passenger --version "$PASSENGER_VERSION" \
	&& apt-get purge -y --auto-remove $buildDeps

# pre-download the PassengerAgent and the NGINX engine
RUN set -x \
	&& passenger-config install-agent \
	&& passenger-config download-nginx-engine

#This will ensure that zombies get re-parented to Tini despite Tini not running as PID 1.
ENV TINI_SUBREAPER=

# Passenger native support for user redmine
RUN mkdir -p /usr/local/bundle/gems/passenger-5.1.4/buildout/ruby/ruby-2.2.7-x86_64-linux
RUN chown redmine /usr/local/bundle/gems/passenger-5.1.4/buildout/ruby/ruby-2.2.7-x86_64-linux
RUN apt-get update
RUN apt-get install -y gcc make

# Configure Redmine for load-balancing cluster
ADD configuration.yml /usr/src/redmine/config/configuration.yml

CMD ["passenger", "start"]
