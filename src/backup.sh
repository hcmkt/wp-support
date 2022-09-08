#!/bin/bash

source "$(cd "$(dirname "$0")"/.. || exit; pwd)/.env"
ssh "$HOST" "$WP db export - --path=$WP_DIR | gzip -c" >"$DIR/db.sql.gz"
ssh "$HOST" "tar -cf - -C $WP_DIR/ wp-content/{languages,plugins,themes} | gzip -c" >"$DIR/wp-content.tar.gz"
ssh "$HOST" "cat $WP_DIR/wp-config.php" >"$DIR/wp-config.php"
