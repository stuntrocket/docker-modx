#!/bin/sh

 set -e

 check_and_set_db_host() {
      check_mysql_port_tcp
      check_modx_db_host
 }

 check_mysql_port_tcp() {
      if [ -n "$MYSQL_PORT_3306_TCP" ]; then
           set_modx_db_host
      fi
 }

 set_modx_db_host() {
      if [ -z "$MODX_DB_HOST" ]; then
          MODX_DB_HOST='mysql'
      else
          display_warning
      fi
 }

 display_warning() {
      echo >&2 'Warning: MODX_DB_HOST and MYSQL_PORT_3306_TCP found'
      echo >&2 "  Connecting to MODX_DB_HOST ($MODX_DB_HOST)"
      echo >&2 '  instead of the linked mysql container'
 }

 check_modx_db_host() {
      if [ -z "$MODX_DB_HOST" ]; then
          display_error
          exit 1
      fi
 }

 display_error() {
      echo >&2 'Error: missing MODX_DB_HOST and MYSQL_PORT_3306_TCP environment variables'
      echo >&2 '  Did you forget to --link some_mysql_container:mysql or set an external db'
      echo >&2 '  with -e MODX_DB_HOST=hostname:port?'
 }

 set_db_credentials() {
      : ${MODX_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
      if [ "$MODX_DB_USER" = 'root' ]; then
          : ${MODX_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
      fi
      : ${MODX_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
      : ${MODX_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-modx}}
 }

 check_db_credentials() {
      if [ -z "$MODX_DB_PASSWORD" ]; then
          display_password_error
          exit 1
      fi
 }

 display_password_error() {
      echo >&2 'Error: missing required MODX_DB_PASSWORD environment variable'
      echo >&2 '  Did you forget to -e MODX_DB_PASSWORD=... ?'
      echo >&2 '  (Also of interest might be MODX_DB_USER and MODX_DB_NAME.)'
 }

 setup_modx() {
   echo >&2 "MODX config not found in $(pwd) - Creating modx setup in $(pwd)"
	 cat > setup/config.xml <<EOF
<modx>
	<database_type>mysql</database_type>
	<database_server>$MODX_DB_HOST</database_server>
	<database>$MODX_DB_NAME</database>
	<database_user>$MODX_DB_USER</database_user>
	<database_password>$MODX_DB_PASSWORD</database_password>
	<database_connection_charset>utf8</database_connection_charset>
	<database_charset>utf8</database_charset>
	<database_collation>utf8_general_ci</database_collation>
	<table_prefix>$MODX_TABLE_PREFIX</table_prefix>
	<https_port>443</https_port>
	<http_host>localhost</http_host>
	<cache_disabled>0</cache_disabled>

	<inplace>1</inplace>
	<unpacked>0</unpacked>
	<language>en</language>

	<cmsadmin>$MODX_ADMIN_USER</cmsadmin>
	<cmspassword>$MODX_ADMIN_PASSWORD</cmspassword>
	<cmsadminemail>$MODX_ADMIN_EMAIL</cmsadminemail>

	<core_path>/var/www/html/core/</core_path>
	<context_mgr_path>/var/www/html/manager/</context_mgr_path>
	<context_mgr_url>/manager/</context_mgr_url>
	<context_connectors_path>/var/www/html/connectors/</context_connectors_path>
	<context_connectors_url>/connectors/</context_connectors_url>
	<context_web_path>/var/www/html/</context_web_path>
	<context_web_url>/</context_web_url>

	<remove_setup_directory>1</remove_setup_directory>
</modx>
EOF
		chown www-data:www-data setup/config.xml
    php setup/index.php --installmode=new
 }

 upgrade_modx() {
		UPGRADE=$(TERM=dumb php -- "$MODX_VERSION" <<'EOPHP'
<?php
define('MODX_API_MODE', true);
require_once 'index.php';

if (version_compare($modx->getVersionData()['full_version'], $argv[1]) == -1) {
	echo 1;
}
EOPHP
)

    if [ $UPGRADE ]; then
      echo >&2 "Upgrading MODX..."
      php setup/index.php --installmode=upgrade
    fi
 }

 main() {
      set -- "$@"
      if [ "$1" = 'php-fpm' ]; then
          check_and_set_db_host
          set_db_credentials
          check_db_credentials
          if ! [ -e index.php -a -e core/config/config.inc.php ]; then
              setup_modx
          else
              upgrade_modx
          fi
      fi
 }

 main "$@"
 exec "$@"