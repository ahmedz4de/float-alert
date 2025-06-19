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

	local mode="$1"
	local bot_token=$(sed -n '1p' telegram.txt)
	local chat_id=$(sed -n '2p' telegram.txt)
	local isFirstLaunch=1
	local link=$(sed -n '1p' input.txt)
	local key=$(sed -n '2p' input.txt)
	local delay=$(sed -n '3p' input.txt)
	local requestLink=$(transform_link "$link")
	local first=""
	local second=""
	local firstId=""
	local secondId=""

	while true; do
		if [[ "$firstId" != "$secondId" && "$isFirstLaunch" != 1 ]]; then
			name=$(get_listing_data "$second" "name")
			price=$(get_listing_data "$second" "price")
			id=$(get_listing_data "$second" "id")

			if [[ "$mode" == "t" ]]; then
				message="$name"$'\n'"Price: ${price}\$"$'\n'"Link: https://csfloat.com/item/$id"

				curl -s -o /dev/null --fail -X POST "https://api.telegram.org/bot$bot_token/sendMessage" \
				-d chat_id="$chat_id" \
				-d text="$message"

			else
				echo
				echo "$message"
			fi
		fi

		first=$(make_request "$requestLink" "$key")
		firstId=$(get_listing_data "$first" "id")
		sleep "$delay"

		if [[ "$firstId" != "$secondId" && "$isFirstLaunch" != 1 ]]; then
			name=$(get_listing_data "$first" "name")
			price=$(get_listing_data "$first" "price")
			id=$(get_listing_data "$first" "id")

			if [[ "$mode" == "t" ]]; then
				message="$name"$'\n'"Price: ${price}\$"$'\n'"Link: https://csfloat.com/item/$id"

				curl -s -o /dev/null --fail -X POST "https://api.telegram.org/bot$bot_token/sendMessage" \
				-d chat_id="$chat_id" \
				-d text="$message"

			else
				echo
				echo "$message"
			fi
		fi

		second=$(make_request "$requestLink" "$key")
		secondId=$(get_listing_data "$second" "id")
		sleep "$delay"

		isFirstLaunch=0
	done
}


main "$@"
