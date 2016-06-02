#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

$DC -p webitel -f "${DIR}/srv/docker-compose.yml" stop 
$DC -p webitel -f "${DIR}/var/docker-compose.yml" stop
