#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

$DC -p webitel -f "${DIR}/srv/docker-compose.yml" down -v
$DC -p webitel -f "${DIR}/srv/docker-compose.yml" up -d
