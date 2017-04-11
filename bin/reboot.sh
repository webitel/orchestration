#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

$DC -p webitel -f "${DIR}/${WEBITEL_DC}/docker-compose.yml" down
$DC -p webitel -f "${DIR}/${WEBITEL_DC}/docker-compose.yml" up -d
