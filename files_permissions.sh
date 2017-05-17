#!/bin/bash
set -e
#give full file permission access to user redmine
cd /usr/src/redmine
chown -v -R redmine:redmine files log tmp public/plugin_assets
chmod -v -R 755 files log tmp public/plugin_assets
