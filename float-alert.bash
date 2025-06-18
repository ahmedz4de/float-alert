#!/bin/bash

set -euo pipefail

function transform_link(){
	local link=$1
	local strippedLink=${link:27}
	echo "https://csfloat.com/api/v1/listings?limit=1&$strippedLink"
}

function make_request(){
	local response=$(curl -s -X GET $1 -H "Authorization: $2")
	echo "$response"
}

function get_listing_data(){
	local json=$1
	local type=$2

	if [[ "$type" == "id" ]]; then
		echo "$(echo "$json" | jq -r '.data[0].id')"
	elif [[ "$type" == "price" ]]; then
		echo "$(echo "$json" | jq -r '(.data[0].price / 100)')"
	elif [[ "$type" == "name" ]]; then
		echo "$(echo "$json" | jq -r '.data[0].item.market_hash_name')"
	fi
}

function main() {
	clear
	echo "Running..."

	local isFirstLaunch=1
	local link=$1
	local key=$2
	local delay=$3
	local requestLink=$(transform_link "$link")
	local first=""
	local second=""
	local firstId=""
	local secondId=""
	local i=1

	while true; do
		if [[ "$firstId" != "$secondId" && "$isFirstLaunch" != 1 ]]; then
			echo ""
			echo "$(get_listing_data "$second" "name")"
			echo "$(get_listing_data "$second" "price")\$"
			echo "https://csfloat.com/item/$(get_listing_data "$second" "id")"
		fi

		first=$(make_request "$requestLink" "$key")
		firstId=$(get_listing_data "$first" "id")
		sleep "$delay"

		if [[ "$firstId" != "$secondId" && "$isFirstLaunch" != 1 ]]; then
			echo ""
			echo "$(get_listing_data "$first" "name")"
			echo "$(get_listing_data "$first" "price")\$"
			echo "https://csfloat.com/item/$(get_listing_data "$first" "id")"
		fi

		second=$(make_request "$requestLink" "$key")
		secondId=$(get_listing_data "$second" "id")
		sleep "$delay"

		isFirstLaunch=0
	done
}


main "$@"
