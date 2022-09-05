#!/bin/bash

source .env
date_today=$(date "+%Y/%m/%d")
core=$(cat "$DIR/core.txt")
core_update=$(cat "$DIR/core-update.txt")
if [ "$core_update" != "" ] && [ "$core" != "$core_update" ]; then
    printf '"高", "%s", "WordPress本体", "%s", "%s", "有"\n' "$date_today" "$core" "$core_update"
fi
pts=("plugin" "theme")
for pt in "${pts[@]}"; do
    json="$(cat "$DIR/$pt.json")"
    json_len="$(echo "$json" | jq length)"
    for i in $(seq 0 $((json_len - 1))); do
        row="$(echo "$json" | jq ".[$i]")"
        title="$(echo "$row" | jq -r .title)"
        update="$(echo "$row" | jq -r .update)"
        version="$(echo "$row" | jq -r .version)"
        update_version="$(echo "$row" | jq -r .update_version)"
        if [ "$update" != "none" ] && [ "$version" != "$update_version" ]; then
            printf '"低", "%s", "%s", "%s", "%s", "なし"\n' "$date_today" "$title" "$version" "$update_version"
        fi
    done
done
