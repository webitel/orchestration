#!/bin/bash

export COMPOSE_HTTP_TIMEOUT=300
export TIMESTAMP=`date "+%Y-%m-%d" -u`
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"

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

DC="$(which docker-compose)"
if ! type "$DC" > /dev/null; then
  echo "docker-compose version 1.8.0 or greater is required"
  exit 1;
fi
