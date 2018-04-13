#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

if [ "${TFTP_ENABLED}" == "true" ]; then
    $DC -p webitel -f "${DIR}/misc/utils-compose.yml" down -d tftpd
fi
$DC -p webitel -f "${DIR}/${WEBITEL_DC}/docker-compose.yml" down
$DC -p webitel -f "${DIR}/${WEBITEL_DC}/docker-compose.yml" up -d
if [ "${TFTP_ENABLED}" == "true" ]; then
    $DC -p webitel -f "${DIR}/misc/utils-compose.yml" up -d tftpd
fi

docker volume prune -f
