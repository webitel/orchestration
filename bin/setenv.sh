#!/bin/bash

export COMPOSE_HTTP_TIMEOUT=300
export TIMESTAMP=`date "+%Y-%m-%d" -u`
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
export ES_MEMORY="2g"
export ES_MEMORY_LIMIT="4g"
export WEBITEL_DC="default"

if [ ! -f "$DIR/env/environment" ]; then
    echo "$DIR/env/environment not found!"
    cp "$DIR/env/environment.example" "$DIR/env/environment"
fi
. $DIR/env/environment

if [ ! -f "$DIR/env/common" ]; then
    echo "$DIR/env/common not found!"
    cp "$DIR/env/common.example" "$DIR/env/common"
fi

if [ ! -f "$DIR/env/freeswitch" ]; then
    echo "$DIR/env/freeswitch not found!"
    cp "$DIR/env/freeswitch.example" "$DIR/env/freeswitch"
fi

if [ ! -f "$DIR/env/storage" ]; then
    echo "$DIR/env/storage not found!"
    cp "$DIR/env/storage.example" "$DIR/env/storage"
fi

if [ ! -f "$DIR/env/archive" ]; then
    echo "$DIR/env/archive not found!"
    cp "$DIR/env/archive.example" "$DIR/env/archive"
fi

if [ ! -f "${WEBITEL_DIR}/ssl/token.key" ]; then
    echo "${WEBITEL_DIR}/ssl/token.key not found!"
    mkdir -p "${WEBITEL_DIR}/ssl/"
    OPENSSL="$(which openssl)"
    if ! type "$OPENSSL" > /dev/null; then
        echo "openssl is required"
        exit 1;
    fi
    $OPENSSL genrsa -out "${WEBITEL_DIR}/ssl/token.key" 4096
fi

DC="$(which docker-compose)"
if ! type "$DC" > /dev/null; then
    echo "docker-compose version 1.8.0 or greater is required"
    exit 1;
fi

 if [ ! -d "${WEBITEL_DIR}/esdata6" ]; then
    mkdir -p "${WEBITEL_DIR}/esdata6/0"
    mkdir "${WEBITEL_DIR}/esdata6/1"
    mkdir "${WEBITEL_DIR}/esdata6/backups"
    chown -R 1000:1000 "${WEBITEL_DIR}/esdata6"
fi
