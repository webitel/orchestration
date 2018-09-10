#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
        "MASTER") echo "restart FreeSWITCH on primary"
                  /usr/bin/docker restart freeswitch
                  exit 0
                  ;;
        "BACKUP") echo "stop FreeSWITCH on secondary"
                  /usr/bin/docker stop freeswitch
                  exit 0
                  ;;
        "FAULT")  echo "FAULT state"
                  exit 0
                  ;;
        *)        echo "unknown state"
                  exit 1
                  ;;
esac
