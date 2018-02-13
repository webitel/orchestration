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
    "backup")
        docker exec -t mongo bash -c 'mongodump -h mongo -o /data/db/dump/'
        docker exec -e PGPASSWORD=webitel -t postgres bash -c 'pg_dump -U webitel webitel > /var/lib/postgresql/data/dump.sql'
        if [ ! -d "${WEBITEL_DIR}/backup/" ]; then
            mkdir ${WEBITEL_DIR}/backup/
        fi
        docker exec -it elasticsearch curl -XPUT -d '{"type": "fs","settings": {"location": "es"}}' -H 'Content-Type: application/json' localhost:9200/_snapshot/es
        docker exec -it elasticsearch curl -XPUT "localhost:9200/_snapshot/es/snapshot?wait_for_completion=true"
        
        tar -cvzf ${WEBITEL_DIR}/backup/$TIMESTAMP.tgz "${WEBITEL_DIR}/esdata6/backups/es" "${DIR}/env" "${DIR}/custom" "${WEBITEL_DIR}/ssl" "${WEBITEL_DIR}/db" "${WEBITEL_DIR}/mongodb/dump" "${WEBITEL_DIR}/pgsql/dump.sql"
        
        docker exec -it elasticsearch curl -XDELETE localhost:9200/_snapshot/es
        rm -rf ${WEBITEL_DIR}/mongodb/dump
        rm -rf $${WEBITEL_DIR}/esdata6/backups/es
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
        rename -v 's/1/2/gi' ${WEBITEL_DIR}/ssl/*1.pem
        docker exec -t nginx bash -c 'cp /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem /etc/nginx/ssl/'
        docker exec -t nginx bash -c 'cp /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/nginx/ssl/'
        if [ -f "${WEBITEL_DIR}/ssl/fullchain1.pem" ]; then
            docker exec -t nginx bash -c 'cat /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem > /etc/nginx/ssl/wss.pem'
            docker exec -t nginx bash -c 'cat /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem > /etc/nginx/ssl/tls.pem'
            docker exec -t nginx bash -c 'cat /etc/letsencrypt/archive/$WEBITEL_HOST/fullchain1.pem /etc/letsencrypt/archive/$WEBITEL_HOST/privkey1.pem > /etc/nginx/ssl/dtls-srtp.pem'
            docker exec -t freeswitch /usr/local/freeswitch/bin/fs_cli -H 172.17.0.1 -x 'sofia profile internal restart'
            docker exec -t freeswitch /usr/local/freeswitch/bin/fs_cli -H 172.17.0.1 -x 'sofia profile nonreg restart'
            docker restart nginx
        fi
        ;;
    "self-signed-cert")
        curl -o /tmp/ssl.tgz http://files.freeswitch.org/downloads/ssl.ca-0.1.tar.gz
        cd /tmp
        tar zxfv /tmp/ssl.tgz
        cd ssl.ca-0.1/
        perl -i -pe 's/md5/sha256/g' *.sh
        perl -i -pe 's/1024/4096/g' *.sh
        ./new-root-ca.sh
        ./new-server-cert.sh $WEBITEL_HOST
        ./sign-server-cert.sh $WEBITEL_HOST
        cat ${WEBITEL_HOST}.crt ${WEBITEL_HOST}.key > ${WEBITEL_DIR}/ssl/wss.pem
        cat ${WEBITEL_HOST}.crt ${WEBITEL_HOST}.key > ${WEBITEL_DIR}/ssl/tls.pem
        cat ${WEBITEL_HOST}.crt ${WEBITEL_HOST}.key > ${WEBITEL_DIR}/ssl/dtls-srtp.pem
        ;;
    "db-repair")
        printf "Mongo DB repair\n\n"
        $DC -p webitel -f "${DIR}/misc/utils-compose.yml" up mongo-repair
        $DC -p webitel -f "${DIR}/misc/utils-compose.yml" stop mongo-repair 
        $DC -p webitel -f "${DIR}/misc/utils-compose.yml" rm -f mongo-repair
        ;;
    "es526")
        printf "Create snapshot of an index in 5.x and restore it in 6.x.\n\n"
        $DC -p webitel -f "${DIR}/misc/utils-compose.yml" up -d elasticsearch5
        sleep 30s
        docker exec -it elasticsearch5 curl -XPUT -d '{"type": "fs","settings": {"location": "es"}}' -H 'Content-Type: application/json' localhost:9200/_snapshot/es
        docker exec -it elasticsearch5 curl -XPUT "localhost:9200/_snapshot/es/snapshot?wait_for_completion=true"
        mkdir -p "$${WEBITEL_DIR}/esdata6/"
        mv "$${WEBITEL_DIR}/elasticsearch5/backups" "$${WEBITEL_DIR}/esdata6/"
        docker exec -it elasticsearch5 curl -XDELETE localhost:9200/_snapshot/es
        $DC -p webitel -f "${DIR}/misc/utils-compose.yml" rm -f elasticsearch5

        $DC -p webitel -f "${DIR}/misc/utils-compose.yml" up -d elasticsearch6
        sleep 30s
        docker exec -it elasticsearch6 curl -XPUT -d '{"type": "fs","settings": {"location": "es"}}' -H 'Content-Type: application/json' localhost:9200/_snapshot/es
        docker exec -it elasticsearch6 curl -XPUT "localhost:9200/_snapshot/es/snapshot_1/_restore"
        docker exec -it elasticsearch6 curl -XDELETE localhost:9200/_snapshot/es
        $DC -p webitel -f "${DIR}/misc/utils-compose.yml" rm -f elasticsearch6

        rm -rf $${WEBITEL_DIR}/elasticsearch5/backups
        rm -rf $${WEBITEL_DIR}/esdata6/backups
        ;;
    "help")
        echo "fs - Run FreeSWITCH client"
        echo "backup - Backup webitel files and databases"
        echo "cdr2csv - Export webitel CDR from MongoDB into CSV file"
        echo "db-repair - Repair MongoDB after crash"
        echo "letsencrypt - Get your free HTTPS certificate"
        exit 0
        ;;
    *)
        printf "Webitel ${WEBITEL_DC} containers\n\n"
        $DC -p webitel -f "${DIR}/${WEBITEL_DC}/docker-compose.yml" $1 $2 $3 $4 $5 $6 $7 $8 $9
        ;;
esac
