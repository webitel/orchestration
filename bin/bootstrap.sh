#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"

echo "********************************************"
echo "webitel v${WEBITEL_VERSION} software stack orchestration"
echo "********************************************"

case "$1" in
    "var")
        printf "Logs and broker containers\n\n"
        $DC -p webitel -f "${DIR}/var/docker-compose.yml" $2 $3 $4
        ;;
    "dev")
        printf "Webitel developers stack\n\n"
        $DC -p webitel -f "${DIR}/dev/docker-compose.yml" $2 $3 $4
        ;;
    "pull")
        printf "Pull new images\n\n"
        $DC -p webitel -f "${DIR}/var/docker-compose.yml" pull
        $DC -p webitel -f "${DIR}/srv/docker-compose.yml" pull
        ;;
    "backup")
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" up backupDB
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" rm -f backupDB
        tar -cvzf ${WEBITEL_DIR}/backup/$TIMESTAMP.tgz "${WEBITEL_DIR}/ssl" "${WEBITEL_DIR}/db" "${WEBITEL_DIR}/elasticsearch" "${WEBITEL_DIR}/backup/dump"
        rm -rf ${WEBITEL_DIR}/backup/dump
        find ${WEBITEL_DIR}/backup/ -maxdepth 1 -mtime +$BACKUP_LIFETIME_DAYS -type f -exec rm {} \;
        ;;
    "fs")
        docker run -i --rm -t "webitel/freeswitch:${WEBITEL_VERSION}" fs_cli -H 172.17.0.1
        ;;
    "help")
        echo "var - Logs and broker containers"
        echo "dev - Webitel containers in the development mode"
        echo "pull - Pull new images"
        echo "backup - Backup webitel files"
        echo "fs - Run FreeSWITCH client"
        exit 1
        ;;
    *)
        printf "Webitel containers\n\n"
        $DC -p webitel -f "${DIR}/srv/docker-compose.yml" $1 $2 $3 $4
        ;;
esac