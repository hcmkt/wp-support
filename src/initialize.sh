#!/bin/bash

root_dir="$(
    cd "$(dirname "$0")"/.. || exit
    pwd
)"
json_yaml="$root_dir/env.yaml"
env_file="$root_dir/.env"
connection="$(yq <"$json_yaml" -o=json '.' | jq "map(select(.name == \"$1\"))")"
{
    echo "DIR=$root_dir/data/$(date '+%Y-%m-%d')_$1_$2"
    echo "ENV=$2"
    echo ""
    echo "HOST=$(echo "$connection" | jq ".[] | .\"$2\" | .host")"
    echo "PASS=$(echo "$connection" | jq ".[] | .\"$2\" | .pass")"
    echo "WP=$(echo "$connection" | jq ".[] | .\"$2\" | .wp_cmd")"
    echo "WP_DIR=$(echo "$connection" | jq ".[] | .\"$2\" | .wp_dir")"
    echo "WP_LOG_FILE=$(echo "$connection" | jq ".[] | .\"$2\" | .wp_log")"
    echo ""
    echo "HOST_STG=$(echo "$connection" | jq '.[] | .stg | .host')"
    echo "PASS_STG=$(echo "$connection" | jq '.[] | .stg | .pass')"
    echo "WP_STG=$(echo "$connection" | jq '.[] | .stg | .wp_cmd')"
    echo "WP_DIR_STG=$(echo "$connection" | jq '.[] | .stg | .wp_dir')"
    echo "WP_LOG_FILE_STG=$(echo "$connection" | jq '.[] | .stg | .wp_log')"
    echo ""
    echo "HOST_PROD=$(echo "$connection" | jq '.[] | .prod | .host')"
    echo "PASS_PROD=$(echo "$connection" | jq '.[] | .prod | .pass')"
    echo "WP_PROD=$(echo "$connection" | jq '.[] | .prod | .wp_cmd')"
    echo "WP_DIR_PROD=$(echo "$connection" | jq '.[] | .prod | .wp_dir')"
    echo "WP_LOG_FILE_PROD=$(echo "$connection" | jq '.[] | .prod | .wp_log')"
} >"$env_file"
