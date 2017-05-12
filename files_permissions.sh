#!/bin/bash
set -e
#give full file permission access to user redmine
sudo chown -R redmine:redmine files log tmp public/plugin_assets
sudo chmod -R 755 files log tmp public/plugin_assets