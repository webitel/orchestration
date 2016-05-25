#~/bin/bash

set -e

do_test=$(curl --silent -X POST -H 'Content-Type: application/json' -d '{"username":"root","password":"secret"}' "https://${WEBITEL_HOST}/engine/login")

if [ -z "$do_test" ]; then
    exit 1
fi

echo $do_test
