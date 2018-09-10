#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
        "MASTER") echo "restart on master"
                  /usr/bin/docker restart wconsole
                  /usr/bin/docker restart engine
                  exit 0
                  ;;
        "BACKUP") echo "stop on backup"
                  /usr/bin/docker exec -it freeswitch /bin/sh -c "/usr/local/freeswitch/bin/fs_cli -H 172.17.0.1 -x 'reload mod_verto'"
                  /bin/sleep 3s
                  /usr/bin/docker stop engine
                  /usr/bin/docker stop wconsole
                  exit 0
                  ;;
        "FAULT")  echo "FAULT state"
                  exit 0
                  ;;
        *)        echo "unknown state"
                  exit 1
                  ;;
esac
