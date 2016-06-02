#!/bin/bash

export TIMESTAMP=`date "+%Y-%m-%d"`
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

if [ ! -f "$DIR/env/cdr" ]; then
    echo "$DIR/env/cdr not found!"
    cp "$DIR/env/cdr.example" "$DIR/env/cdr"
fi

DC="$(which docker-compose)"
if ! type "$DC" > /dev/null; then
  echo "docker-compose version 1.7.0 or greater is required"
  exit 1;
fi
