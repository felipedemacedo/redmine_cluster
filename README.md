# Redmine

A simple modification from the latest version of https://github.com/docker-library/redmine

## List of modifications

* Hability to quickly deal with large amounts of files in "files" directory of Redmine application. The original version would spend too much time changing file permissions of ALL already existing Redmine attachments before starting the web server.

## How to use it

This command starts a Docker container with name redmine at port 80. 
All the files inside /path/in/host will be mounted on /usr/src/redmine/files wich is the folder for attachments on Redmine.

```console
docker run -d \
--name redmine \
-p 80:3000 \
-v /path/in/host:/usr/src/redmine/files \
felipederodrigues/redmine:passenger
```

This command starts a Docker container with privileged access and name redmine at port 80. 
Also this configuration lets you set the database information from outside the container (database.yml file).

```console
docker run -d \
--privileged \
-h redmine \
--restart always \
--name redmine \
-p 80:3000 \
-v /home/ubuntu/cluster_redmine/config/database.yml:/usr/src/redmine/config/database.yml \
-v /home/ubuntu/cluster_redmine/files:/usr/src/redmine/files \
felipederodrigues/redmine:passenger
```

Example of database.yml file:
Don't forget to insert host (x.x.x.x) and password (yourPassowrd) information. This file tells your Redmine application how to connect into database.
```console
# Default setup is given for MySQL with ruby1.9.
# Examples for PostgreSQL, SQLite3 and SQL Server can be found at the end.
# Line indentation must be 2 spaces (no tabs).

production:
  adapter: mysql2
  database: redmine
  host: x.x.x.x
  #port: 3116
  username: redmine
  password: "yourPassword"
  encoding: utf8

development:
  adapter: mysql2
  database: redmine_development
  host: x.x.x.x
  #port: 3116
  username: redmine
  password: "yourPass"
  encoding: utf8

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: mysql2
  database: redmine_test
  host: xxx.xxx.xxx.xxx
  #port: 3116
  username: redmine
  password: "yourPassword"
  encoding: utf8

# PostgreSQL configuration example
#production:
#  adapter: postgresql
#  database: redmine
#  host: 172.17.0.3
#  username: postgres
#  password: "postgres"

# SQLite3 configuration example
#production:
#  adapter: sqlite3
#  database: db/redmine.sqlite3

# SQL Server configuration example
#production:
#  adapter: sqlserver
#  database: redmine
#  host: 172.17.0.3
#  username: jenkins
#  password: jenkins
```


This command starts a Docker container with privileged access and name redmine at port 80. 
Also this configuration lets you set the website url to [server]/redmine (environment.rb file).

```console
docker run -d \
--privileged \
-h redmine \
--restart always \
--name redmine \
-p 80:3000 \
-v /home/ubuntu/cluster_redmine/config/database.yml:/usr/src/redmine/config/database.yml \
-v /home/ubuntu/cluster_redmine/config/environment.rb:/usr/src/redmine/config/environment.rb \
-v /home/ubuntu/cluster_redmine/files:/usr/src/redmine/files \
felipederodrigues/redmine:passenger
```

Example of environment.rb file with "/redmine" URL redirect:
```console
# Load the Rails application
require File.expand_path('../application', __FILE__)

# Make sure there's no plugin in vendor/plugin before starting
vendor_plugins_dir = File.join(Rails.root, "vendor", "plugins")
if Dir.glob(File.join(vendor_plugins_dir, "*")).any?
  $stderr.puts "Plugins in vendor/plugins (#{vendor_plugins_dir}) are no longer allowed. " +
    "Please, put your Redmine plugins in the `plugins` directory at the root of your " +
    "Redmine directory (#{File.join(Rails.root, "plugins")})"
  exit 1
end

RedmineApp::Application.routes.default_scope = "/redmine"
# Initialize the Rails application
Rails.application.initialize!
```


