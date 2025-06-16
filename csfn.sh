#!/bin/bash

set -euo pipefail

clear
echo "Running..."
echo ""

constlink="https://csfloat.com/item/"
link=$1
search="${link#*\?}"
token=$2
sleeptime=$3

old=$(curl -s -X GET "https://csfloat.com/api/v1/listings?limit=1&$search" \
-H "Authorization: $token")

sleep $sleeptime

new=$(curl -s -X GET "https://csfloat.com/api/v1/listings?limit=1&$search" \
-H "Authorization: $token")

if [[ "$(echo "$old" | jq -r '.data[0].id')" == "$(echo "$new" | jq -r '.data[0].id')" ]]; then
    :
else
    echo "$new" | jq -r --arg constlink "$constlink" '.data[0] | "\(.item.market_hash_name)\n\((.price / 100) | tostring)$\n\($constlink)\(.id)"'
    echo ""
fi

sleep $sleeptime

while :
do
    old=$new

    new=$(curl -s -X GET "https://csfloat.com/api/v1/listings?limit=1&$search" \
    -H "Authorization: $token")

    if [[ "$(echo "$old" | jq -r '.data[0].id')" == "$(echo "$new" | jq -r '.data[0].id')" ]]; then
        :
    else
        echo "$new" | jq -r --arg constlink "$constlink" '.data[0] | "\(.item.market_hash_name)\n\((.price / 100) | tostring)$\n\($constlink)\(.id)"'
        echo ""
    fi

    sleep $sleeptime
done
