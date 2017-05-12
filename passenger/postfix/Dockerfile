FROM felipederodrigues/redmine_cluster:passenger

#POSTFIX config based on https://github.com/catatnight/docker-postfix

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Start editing
# Install package here for cache
RUN apt-get -y install supervisor postfix sasl2-bin opendkim opendkim-tools

# Add files
ADD install.sh /opt/install.sh
RUN chmod +x /opt/install.sh

# Run
CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

# Start REDMINE SERVER WITH PASSENGER
CMD ["passenger", "start"]