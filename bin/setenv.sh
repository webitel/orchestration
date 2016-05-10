#!/bin/bash

# root password
export WEBITEL_PASS="secret"

# host settings
export WEBITEL_WS="ws"
export WEBITEL_SSL="off"
export WEBITEL_PROTO="http"
export WEBITEL_HOST="$(hostname -I | cut -d' ' -f1)"

# webitel settings
export WEBITEL_VERSION="3.3.0"
export WEBITEL_DIR="/opt/webitel"
export WEBITEL_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# backup settings
export TIMESTAMP=`date "+%Y-%m-%d"`
export BACKUP_LIFETIME_DAYS="5"

DC="$(which docker-compose)"
if ! type "$DC" > /dev/null; then
  echo "docker-compose version 1.6.0 or greater is required"
  exit 1;
fi
