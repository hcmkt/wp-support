#!/bin/bash

# shellcheck source=/dev/null
source "$(cd "$(dirname "$0")"/.. || exit; pwd)/.env"
sshpass -p "$PASS" ssh "$HOST" "$WP db export - --path=$WP_DIR | gzip -c" >"$DIR/db.sql.gz"
sshpass -p "$PASS" ssh "$HOST" "tar -cf - -C $WP_DIR/ wp-content/{languages,plugins,themes} | gzip -c" >"$DIR/wp-content.tar.gz"
sshpass -p "$PASS" ssh "$HOST" "cat $WP_DIR/wp-config.php" >"$DIR/wp-config.php"
