<?php
define( 'WP_DEBUG', false );
if (WP_DEBUG) {
    define( 'WP_DEBUG_LOG', true );
    define( 'WP_DEBUG_DISPLAY', false );
    @ini_set( 'display_errors', 0 );
}
