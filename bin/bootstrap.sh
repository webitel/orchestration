#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

echo "********************************************"
echo "webitel ${WEBITEL_VERSION} software stack orchestration"
echo "********************************************"

case "$1" in
    "dev")
        printf "Webitel developers stack\n\n"
        $DC -p webitel -f "${DIR}/dev/docker-compose.yml" $2 $3 $4
        ;;
    "custom")
        printf "Webitel custom docker-compose file\n\n"
        $DC -p webitel -f "${DIR}/$2/docker-compose.yml" $3 $4 $5
        ;;
    "archive")
        printf "Webitel Sorage stack\n\n"
        if [ ! -f "$DIR/env/archive" ]; then
            echo "$DIR/env/archive not found!"
            cp "$DIR/env/archive.example" "$DIR/env/archive"
        fi
        $DC -p webitel -f "${DIR}/misc/archive-compose.yml" $2 $3 $4
        ;;
    "mini")
        printf "Webitel minimal stack\n\n"
        $DC -p webitel -f "${DIR}/misc/mini-compose.yml" $2 $3 $4
        ;;
    "backup")
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" up backupDB
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" rm -f backupDB
        tar -cvzf ${WEBITEL_DIR}/backup/$TIMESTAMP.tgz "${DIR}/env" "${WEBITEL_DIR}/ssl" "${WEBITEL_DIR}/db" "${WEBITEL_DIR}/backup/dump"
        rm -rf ${WEBITEL_DIR}/backup/dump
        find ${WEBITEL_DIR}/backup/ -maxdepth 1 -mtime +$BACKUP_LIFETIME_DAYS -type f -exec rm {} \;
        ;;
    "cdr2csv")
        if [ ! -f "${WEBITEL_DIR}/export/bin/db2scv.sh" ]; then
            echo "db2scv.sh not found!"
            mkdir -p "${WEBITEL_DIR}/export/bin"
            cp "$DIR/bin/db2scv.sh" "${WEBITEL_DIR}/export/bin/db2scv.sh"
            chmod +x "${WEBITEL_DIR}/export/bin/db2scv.sh"
        fi
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" up exportDB
        $DC -p webitel -f "${DIR}/misc/docker-compose.yml" rm -f exportDB
        gzip ${WEBITEL_DIR}/export/cdr-${TIMESTAMP}.csv
        find ${WEBITEL_DIR}/export/ -maxdepth 1 -mtime +$BACKUP_LIFETIME_DAYS -type f -exec rm {} \;
        ;;
    "fs")
        docker run -i --rm -t "webitel/freeswitch:${WEBITEL_VERSION}" fs_cli -H 172.17.0.1
        ;;
    "help")
        echo "dev - Webitel containers in the development mode"
        echo "backup - Backup webitel files"
        echo "cdr2csv - Export webitel CDR from MongoDB into CSV file"
        echo "archive - Webitel archive storage only"
        echo "fs - Run FreeSWITCH client"
        exit 0
        ;;
    *)
        printf "Webitel containers\n\n"
        $DC -p webitel -f "${DIR}/srv/docker-compose.yml" $1 $2 $3 $4
        ;;
esac
