# Redmine

A simple modification from the latest version of https://github.com/docker-library/redmine

## List of modifications

* Hability to quickly deal with large amounts of files in "files" directory of Redmine application. The original version would spend too much time changing file permissions of ALL already existing Redmine attachments before starting the web server. You can now manually trigger the ownership change of files using the command:
```console
docker exec -ti redmine bash -c 'exec /files_permissions.sh'
```
* Added mail sending with PostFix (felipederodrigues/redmine_cluster:latest_postfix or felipederodrigues/redmine_cluster:passenger_postfix)
* Fixed Tini to properly deal with Passenger (zombie reaping is now ON!)
* Set timezone of server to Brazil


## How to use it

This command starts a Docker container with privileged access and name 'redmine' at port 80. 
All the files inside /path/in/host (outside the container) will be mounted on /usr/src/redmine/files (inside the container) wich is the folder for attachments on Redmine.
Also this option felipederodrigues/redmine_cluster:passenger comes with Passenger Standalone instead of Webrick. Passenger is much more indicated for production environments.

```console
docker run -d \
--name redmine \
--privileged \
-p 80:3000 \
-v /path/in/host:/usr/src/redmine/files \
felipederodrigues/redmine_cluster:passenger
```

This command starts a Docker container named 'redmine' at port 80. 
Also this configuration lets you set the database information from outside the container (database.yml file).

```console
docker run -d \
--name redmine \
-p 80:3000 \
-v /home/ubuntu/cluster_redmine/config/database.yml:/usr/src/redmine/config/database.yml \
felipederodrigues/redmine_cluster:passenger
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


This command starts a Docker container named 'redmine' at port 80. 
Also this configuration lets you set the website url to [server]/redmine (environment.rb file).

```console
docker run -d \
-h redmine \
--restart always \
--name redmine \
-p 80:3000 \
-v /home/ubuntu/cluster_redmine/config/environment.rb:/usr/src/redmine/config/environment.rb \
felipederodrigues/redmine_cluster:passenger
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

This command starts a Docker container named 'redmine' at port 80. It also includes port 25 for mail sending with PostFix. 
Mail configuration must be defined or else Redmine won't be able to send mails with PostFix. (configuration.yml file).


```console
docker run -d \
--name redmine \
-p 80:3000 -p 25:25 \
-v /home/ubuntu/cluster_redmine/config/configuration.yml:/usr/src/redmine/config/configuration.yml \
felipederodrigues/redmine_cluster:passenger_postfix
```

Example of configuration.yml file:
```console
# = Redmine configuration file
#
# Each environment has it's own configuration options.  If you are only
# running in production, only the production block needs to be configured.
# Environment specific configuration options override the default ones.
#
# Note that this file needs to be a valid YAML file.
# DO NOT USE TABS! Use 2 spaces instead of tabs for identation.

# default configuration options for all environments
default:
  # Outgoing emails configuration
  # See the examples below and the Rails guide for more configuration options:
  # http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration
  email_delivery:

  # ==== Simple SMTP server at localhost
  #
  #  email_delivery:
  #    delivery_method: :smtp
  #    smtp_settings:
  #      address: "localhost"
  #      port: 25
  #
  # ==== SMTP server at example.com using LOGIN authentication and checking HELO for foo.com
  #
  #  email_delivery:
  #    delivery_method: :smtp
  #    smtp_settings:
  #      address: "example.com"
  #      port: 25
  #      authentication: :login
  #      domain: 'foo.com'
  #      user_name: 'myaccount'
  #      password: 'password'
  #
  # ==== SMTP server at example.com using PLAIN authentication
  #
  #  email_delivery:
  #    delivery_method: :smtp
  #    smtp_settings:
  #      address: "example.com"
  #      port: 25
  #      authentication: :plain
  #      domain: 'example.com'
  #      user_name: 'myaccount'
  #      password: 'password'
  #
  # ==== SMTP server at using TLS (GMail)
  # This might require some additional configuration. See the guides at:
  # http://www.redmine.org/projects/redmine/wiki/EmailConfiguration
  #
  #  email_delivery:
  #    delivery_method: :smtp
  #    smtp_settings:
  #      enable_starttls_auto: true
  #      address: "smtp.gmail.com"
  #      port: 587
  #      domain: "smtp.gmail.com" # 'your.domain.com' for GoogleApps
  #      authentication: :plain
  #      user_name: "your_email@gmail.com"
  #      password: "your_password"
  #
  # ==== Sendmail command
  #
    delivery_method: :sendmail
    smtp_settings:
      address: 127.0.0.1
      port: 25
      domain: your-domain.anything
      user_name: redmine
      password: abc


  # Absolute path to the directory where attachments are stored.
  # The default is the 'files' directory in your Redmine instance.
  # Your Redmine instance needs to have write permission on this
  # directory.
  # Examples:
  # attachments_storage_path: /var/redmine/files
  # attachments_storage_path: D:/redmine/files
  attachments_storage_path:

  # Configuration of the autologin cookie.
  # autologin_cookie_name: the name of the cookie (default: autologin)
  # autologin_cookie_path: the cookie path (default: /)
  # autologin_cookie_secure: true sets the cookie secure flag (default: false)
  autologin_cookie_name:
  autologin_cookie_path:
  autologin_cookie_secure:

  # Configuration of SCM executable command.
  #
  # Absolute path (e.g. /usr/local/bin/hg) or command name (e.g. hg.exe, bzr.exe)
  # On Windows + CRuby, *.cmd, *.bat (e.g. hg.cmd, bzr.bat) does not work.
  #
  # On Windows + JRuby 1.6.2, path which contains spaces does not work.
  # For example, "C:\Program Files\TortoiseHg\hg.exe".
  # If you want to this feature, you need to install to the path which does not contains spaces.
  # For example, "C:\TortoiseHg\hg.exe".
  #
  # Examples:
  # scm_subversion_command: svn                                       # (default: svn)
  # scm_mercurial_command:  C:\Program Files\TortoiseHg\hg.exe        # (default: hg)
  # scm_git_command:        /usr/local/bin/git                        # (default: git)
  # scm_cvs_command:        cvs                                       # (default: cvs)
  # scm_bazaar_command:     bzr.exe                                   # (default: bzr)
  # scm_darcs_command:      darcs-1.0.9-i386-linux                    # (default: darcs)
  #
  scm_subversion_command:
  scm_mercurial_command:
  scm_git_command:
  scm_cvs_command:
  scm_bazaar_command:
  scm_darcs_command:

  # SCM paths validation.
  #
  # You can configure a regular expression for each SCM that will be used to
  # validate the path of new repositories (eg. path entered by users with the
  # "Manage repositories" permission and path returned by reposman.rb).
  # The regexp will be wrapped with \A \z, so it must match the whole path.
  # And the regexp is case sensitive.
  #
  # You can match the project identifier by using %project% in the regexp.
  #
  # You can also set a custom hint message for each SCM that will be displayed
  # on the repository form instead of the default one.
  #
  # Examples:
  # scm_subversion_path_regexp: file:///svnpath/[a-z0-9_]+
  # scm_subversion_path_info: SVN URL (eg. file:///svnpath/foo)
  #
  # scm_git_path_regexp: /gitpath/%project%(\.[a-z0-9_])?/
  #
  scm_subversion_path_regexp:
  scm_mercurial_path_regexp:
  scm_git_path_regexp:
  scm_cvs_path_regexp:
  scm_bazaar_path_regexp:
  scm_darcs_path_regexp:
  scm_filesystem_path_regexp:

  # Absolute path to the SCM commands errors (stderr) log file.
  # The default is to log in the 'log' directory of your Redmine instance.
  # Example:
  # scm_stderr_log_file: /var/log/redmine_scm_stderr.log
  scm_stderr_log_file:

  # Key used to encrypt sensitive data in the database (SCM and LDAP passwords).
  # If you don't want to enable data encryption, just leave it blank.
  # WARNING: losing/changing this key will make encrypted data unreadable.
  #
  # If you want to encrypt existing passwords in your database:
  # * set the cipher key here in your configuration file
  # * encrypt data using 'rake db:encrypt RAILS_ENV=production'
  #
  # If you have encrypted data and want to change this key, you have to:
  # * decrypt data using 'rake db:decrypt RAILS_ENV=production' first
  # * change the cipher key here in your configuration file
  # * encrypt data using 'rake db:encrypt RAILS_ENV=production'
  database_cipher_key:

  # Set this to false to disable plugins' assets mirroring on startup.
  # You can use `rake redmine:plugins:assets` to manually mirror assets
  # to public/plugin_assets when you install/upgrade a Redmine plugin.
  #
  #mirror_plugins_assets_on_startup: false

  # Your secret key for verifying cookie session data integrity. If you
  # change this key, all old sessions will become invalid! Make sure the
  # secret is at least 30 characters and all random, no regular words or
  # you'll be exposed to dictionary attacks.
  #
  # If you have a load-balancing Redmine cluster, you have to use the
  # same secret token on each machine.
  #secret_token: 'change it to a long random string'

  # Requires users to re-enter their password for sensitive actions (editing
  # of account data, project memberships, application settings, user, group,
  # role, auth source management and project deletion). Disabled by default.
  # Timeout is set in minutes.
  #
  #sudo_mode: true
  #sudo_mode_timeout: 15

  # Absolute path (e.g. /usr/bin/convert, c:/im/convert.exe) to
  # the ImageMagick's `convert` binary. Used to generate attachment thumbnails.
  #imagemagick_convert_command:

  # Configuration of RMagick font.
  #
  # Redmine uses RMagick in order to export gantt png.
  # You don't need this setting if you don't install RMagick.
  #
  # In CJK (Chinese, Japanese and Korean),
  # in order to show CJK characters correctly,
  # you need to set this configuration.
  #
  # Because there is no standard font across platforms in CJK,
  # you need to set a font installed in your server.
  #
  # This setting is not necessary in non CJK.
  #
  # Examples for Japanese:
  #   Windows:
  #     rmagick_font_path: C:\windows\fonts\msgothic.ttc
  #   Linux:
  #     rmagick_font_path: /usr/share/fonts/ipa-mincho/ipam.ttf
  #
  rmagick_font_path:

  # Maximum number of simultaneous AJAX uploads
  #max_concurrent_ajax_uploads: 2

  # Configure OpenIdAuthentication.store
  #
  # allowed values: :memory, :file, :memcache
  #openid_authentication_store: :memory

# specific configuration options for production environment
# that overrides the default ones
production:

# specific configuration options for development environment
# that overrides the default ones
development:

```

