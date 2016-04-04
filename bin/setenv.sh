#!/bin/bash

export WEBITEL_SSL="off"
export WEBITEL_PROTO="http"
export WEBITEL_HOST="webitel.lo"
export WEBITEL_PASS="secret"
export WEBITEL_VERSION="3.3.0"
export WEBITEL_DIR="/opt/webitel"
export WEBITEL_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
export TIMESTAMP=`date "+%Y-%m-%d"`
export BACKUP_LIFETIME_DAYS="5"
