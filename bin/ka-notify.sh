#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
        "MASTER") echo "restart wconsole on master"
                  /usr/bin/docker restart wconsole
                  /usr/bin/docker restart engine
                  exit 0
                  ;;
        "BACKUP") echo "stop on backup"
                  /usr/bin/docker stop wconsole
                  /usr/bin/docker stop engine
                  exit 0
                  ;;
        "FAULT")  echo "FAULT state"
                  exit 0
                  ;;
        *)        echo "unknown state"
                  exit 1
                  ;;
esac
