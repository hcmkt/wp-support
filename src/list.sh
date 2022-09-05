#!/bin/bash

source .env
case "$1" in
"stg")
    ssh "$HOST" "cd $WP_DIR; $WP core version" >"$DIR/core.txt"
    ssh "$HOST" "cd $WP_DIR; $WP core check-update --format=json | jq -r '[.[] | .version] | max'" >"$DIR/core-update.txt"
    ssh "$HOST" "cd $WP_DIR; $WP plugin list --fields=name,title,status,update,version,update_version --format=json" | jq >"$DIR/plugin.json"
    ssh "$HOST" "cd $WP_DIR; $WP theme list --fields=name,title,status,update,version,update_version --format=json" | jq >"$DIR/theme.json"
    ;;
"prod")
    ssh "$HOST" "cd $WP_DIR; $WP core version" >"$DIR/core.txt"
    ssh "$HOST" "cd $WP_DIR; $WP plugin list --fields=name,title,status,update,version,update_version --format=json" | jq >"$DIR/plugin-prod.json"
    ssh "$HOST" "cd $WP_DIR; $WP theme list --fields=name,title,status,update,version,update_version --format=json" | jq >"$DIR/theme-prod.json"
    ssh "$HOST_STG" "cd $WP_DIR_STG; $WP_STG core version" >"$DIR/core-update.txt"
    ssh "$HOST_STG" "cd $WP_DIR_STG; $WP_STG plugin list --format=json" | jq >"$DIR/plugin-stg.json"
    ssh "$HOST_STG" "cd $WP_DIR_STG; $WP_STG theme list --format=json" | jq >"$DIR/theme-stg.json"
    pts=("plugin" "theme")
    for pt in "${pts[@]}"; do
        json_prod=$(cat "$DIR/$pt-prod.json")
        json_prod_len=$(echo "$json_prod" | jq length)
        json_stg=$(cat "$DIR/$pt-stg.json")
        json_stg_len=$(echo "$json_stg" | jq length)
        pt_json=""
        if [ "$json_prod_len" -gt 0 ]; then
            pt_json=[
            for i in $(seq 0 $((json_prod_len - 1))); do
                row_prod="$(echo "$json_prod" | jq ".[$i]")"
                name_prod="$(echo "$row_prod" | jq -r .name)"
                title_prod="$(echo "$row_prod" | jq -r .title)"
                status_prod="$(echo "$row_prod" | jq -r .status)"
                update_prod="$(echo "$row_prod" | jq -r .update)"
                version_prod="$(echo "$row_prod" | jq -r .version)"
                update_version_prod="$(echo "$row_prod" | jq -r .update_version)"
                if [ "$update_prod" != "none" ]; then
                    for j in $(seq 0 $((json_stg_len - 1))); do
                        row_stg="$(echo "$json_stg" | jq ".[$j]")"
                        name_stg="$(echo "$row_stg" | jq -r .name)"
                        if [ "$name_stg" = "$name_prod" ]; then
                            update_version_prod="$(echo "$row_stg" | jq -r .version)"
                            break
                        fi
                    done
                fi
                pt_json="$pt_json$(printf '{"name":"%s","title":"%s","status":"%s","update":"%s","version":"%s","update_version":"%s"},' "$name_prod" "$title_prod" "$status_prod" "$update_prod" "$version_prod" "$update_version_prod")"
            done
            pt_json=$(echo -n "${pt_json/%?/}")
            pt_json="$pt_json]"
        fi
        echo "$pt_json" | jq >"$DIR/$pt.json"
    done
    ;;
esac
