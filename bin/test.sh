#~/bin/bash

set -e

sleep 1m

do_test=$(curl --silent -X POST -H 'Content-Type: application/json' -d '{"username":"root","password":"secret"}' "http://${WEBITEL_HOST}/engine/login")
user_tst=$(echo $do_test | jq '. | .username' )

if [ -z "$do_test" ]; then
    exit 1
fi

if [[ $user_tst != *root* ]]; then
    exit 1
fi

echo $do_test | jq .
