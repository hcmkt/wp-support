#!/bin/bash

source "$(cd "$(dirname "$0")"/.. || exit; pwd)/.env"

function wp() {
    echo "[$(date -u '+%Y-%m-%d %H:%M:%S %Z')] $WP $1" >>"$DIR/update.log" 2>&1
    sshpass -p "$PASS" ssh "$HOST" "cd $WP_DIR; $WP $1" >>"$DIR/update.log" 2>&1
}

: >"$DIR/update.log"
core_update="$(cat "$DIR/core-update.txt")"
wp "core update --version=$core_update"
wp "core update-db"
pts=("plugin" "theme")
for pt in "${pts[@]}"; do
    json="$(cat "$DIR/$pt.json")"
    json_len="$(echo "$json" | jq length)"
    for i in $(seq 0 $((json_len - 1))); do
        row="$(echo "$json" | jq ".[$i]")"
        name="$(echo "$row" | jq -r .name)"
        update="$(echo "$row" | jq -r .update)"
        version="$(echo "$row" | jq -r .version)"
        update_version="$(echo "$row" | jq -r .update_version)"
        if [ "$update" != "none" ] && [ "$version" != "$update_version" ]; then
            wp "$pt update $name --version=$update_version"
        fi
    done
done
wp "language core update"
wp "language plugin update --all"
wp "language theme update --all"
