#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"

echo "********************************************"
echo "webitel v${WEBITEL_VERSION} software stack orchestration"
echo "********************************************"

DC="$(which docker-compose)"
if ! type "$DC" > /dev/null; then
  echo "docker-compose version 1.6.0 or greater is required"
  exit 1;
fi

case "$1" in
    "esf")
        printf "Elasticsearch and fluent containers\n\n"
        $DC -p webitel -f "${DIR}/esf/docker-compose.yml" $2 $3 $4
        ;;
    "dev")
        printf "Webitel developers stack\n\n"
        $DC -p webitel -f "${DIR}/dev/docker-compose.yml" $2 $3 $4
        ;;
    "backup")
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" up backupDB
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" rm -f backupDB
        tar -cvzf ${WEBITEL_DIR}/backup/backup_$TIMESTAMP.tar.gz "${WEBITEL_DIR}/ssl" "${WEBITEL_DIR}/db" "${WEBITEL_DIR}/elasticsearch" "${WEBITEL_DIR}/backup/dump"
        rm -rf ${WEBITEL_DIR}/backup/dump
        find ${WEBITEL_DIR}/backup/ -maxdepth 1 -mtime +$BACKUP_LIFETIME_DAYS -type f -exec rm {} \;
        ;;
    "fs")
        docker run -i --rm -t "webitel/freeswitch:${WEBITEL_VERSION}" fs_cli -H 172.17.0.1
        ;;
    "help")
        echo "esf - Elasticsearch and fluent containers"
        echo "dev - Webitel containers in the development mode"
        echo "backup - Backup webitel files"
        echo "fs - Run fs_cli container"
        exit 1
        ;;
    *)
        printf "Webitel containers\n\n"
        $DC -p webitel -f "${DIR}/srv/docker-compose.yml" $1 $2 $3 $4
        ;;
esac
