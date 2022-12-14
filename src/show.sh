#!/bin/bash

# shellcheck source=/dev/null
source "$(
    cd "$(dirname "$0")"/.. || exit
    pwd
)/.env"
date_today=$(date "+%Y/%m/%d")
core=$(cat "$DIR/core.txt")
core_update=$(cat "$DIR/core-update.txt")
if [ "$core_update" != "" ] && [ "$core" != "$core_update" ]; then
    IFS="." read -r -a core_versions <<<"$core"
    IFS="." read -r -a core_update_versions <<<"$core_update"
    arr=(0 1)
    importance="低"
    note="なし"
    for v in "${arr[@]}"; do
        if [ "${core_versions[$v]}" \< "${core_update_versions[$v]}" ]; then
            importance="高"
            note="有"
            break
        fi
    done
    printf '"%s", "%s", "WordPress本体", "%s", "%s", "%s"\n' "$importance" "$date_today" "$core" "$core_update" "$note"
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
language=$(cat "$DIR/language-update.txt")
if "$language"; then
    printf '"低", "%s", "翻訳", "-", "-", "なし"\n' "$date_today"
fi
