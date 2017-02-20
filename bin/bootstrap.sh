#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh

date
echo ""
echo "********************************************"
echo "webitel ${WEBITEL_VERSION} software stack orchestration"
echo "********************************************"
echo ""

case "$1" in
    "dev")
        printf "Webitel developers stack\n\n"
        $DC -p webitel -f "${DIR}/dev/docker-compose.yml" $2 $3 $4
        ;;
    "custom")
        printf "Webitel custom docker-compose file\n\n"
        $DC -p webitel -f "${DIR}/custom/docker-compose.yml" $2 $3 $4
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
        docker exec -t mongo bash -c 'mongodump -h mongo -o /data/db/dump/'
        if [ ! -d "${WEBITEL_DIR}/backup/" ]; then
            mkdir ${WEBITEL_DIR}/backup/
        fi
        tar -cvzf ${WEBITEL_DIR}/backup/$TIMESTAMP.tgz "${DIR}/env" "${WEBITEL_DIR}/ssl" "${WEBITEL_DIR}/db" "${WEBITEL_DIR}/mongodb/dump"
        rm -rf ${WEBITEL_DIR}/mongodb/dump
        find ${WEBITEL_DIR}/backup/ -maxdepth 1 -mtime +$BACKUP_LIFETIME_DAYS -type f -exec rm {} \;
        ;;
    "cdr2csv")
        if [ ! -f "$DIR/bin/db2scv.sh" ]; then
            echo "$DIR/bin/db2scv.sh not found!"
            cp "$DIR/bin/db2scv.sh.example" "$DIR/bin/db2scv.sh"
            chmod +x "$DIR/bin/db2scv.sh"
        fi
        docker cp $DIR/bin/db2scv.sh `docker ps|grep mongo|cut -d' ' -f1`:/db2scv.sh
        docker exec -t mongo bash -c '/db2scv.sh'
        if [ ! -d "${WEBITEL_DIR}/export/" ]; then
            mkdir ${WEBITEL_DIR}/export/
        fi
        mv ${WEBITEL_DIR}/mongodb/export/cdr.csv ${WEBITEL_DIR}/export/cdr-${TIMESTAMP}.csv
        gzip ${WEBITEL_DIR}/export/cdr-${TIMESTAMP}.csv
        find ${WEBITEL_DIR}/export/ -maxdepth 1 -mtime +$BACKUP_LIFETIME_DAYS -type f -exec rm {} \;
        ;;
    "fs")
        docker exec -it freeswitch /usr/local/freeswitch/bin/fs_cli -H 172.17.0.1
        ;;
    "letsencrypt")
        echo "boostraping dependencies to work with letsencrypt and acquiring the certificates"
        docker exec -t nginx bash -c 'cd /opt/letsencrypt/ && ./letsencrypt-auto --config ./www/site.conf certonly --agree-tos -n'
        docker exec -t nginx bash -c 'cp /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem /etc/nginx/ssl/'
        docker exec -t nginx bash -c 'cp /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/nginx/ssl/'
        echo ""
        echo ""
        echo "the files privkey1 and fullchain1 were saved locally in the ${WEBITEL_DIR}/ssl/."

        docker exec -t nginx bash -c 'cat /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem > /etc/nginx/ssl/wss.pem'
        docker exec -t nginx bash -c 'cat /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem > /etc/nginx/ssl/tls.pem'
        docker exec -t nginx bash -c 'cat /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem > /etc/nginx/ssl/dtls-srtp.pem'

        docker exec -t freeswitch /usr/local/freeswitch/bin/fs_cli -H 172.17.0.1 -x 'sofia profile internal restart'
        docker exec -t freeswitch /usr/local/freeswitch/bin/fs_cli -H 172.17.0.1 -x 'sofia profile nonreg restart'
        docker restart nginx
        ;;
    "help")
        echo "fs - Run FreeSWITCH client"
        echo "dev - Webitel containers in the development mode"
        echo "backup - Backup webitel files"
        echo "cdr2csv - Export webitel CDR from MongoDB into CSV file"
        echo "archive - Webitel archive storage only"
        echo "letsencrypt - Get your free HTTPS certificate"
        exit 0
        ;;
    *)
        printf "Webitel containers\n\n"
        $DC -p webitel -f "${DIR}/srv/docker-compose.yml" $1 $2 $3 $4
        ;;
esac
