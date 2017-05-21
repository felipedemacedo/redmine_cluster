FROM felipederodrigues/redmine_cluster:latest

#POSTFIX

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Install
RUN apt-get -y install postfix

# Basic Config
RUN sed -i.bak s/'inet_interfaces = all'/'inet_interfaces = loopback-only'/g /etc/postfix/main.cf 
RUN sed -i.bak s/'mydestination = 200591939db7, localhost.localdomain, , localhost'/'mydestination = $myhostname, localhost.$mydomain, $mydomain'/g /etc/postfix/main.cf 

# TLS (Encrypt)
RUN echo 'smtp_tls_security_level = may' >> /etc/postfix/main.cf

# Configure Redmine for SendMail
ADD configuration.yml /usr/src/redmine/config/configuration.yml

# Start REDMINE SERVER
CMD ["bash" , "-c" , "service postfix stop; service postfix start; /docker-entrypoint.sh rails server -b 0.0.0.0"]