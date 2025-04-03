#!/bin/bash
set -euo pipefail

##########################################################################
# Load environment variables
##########################################################################
if [[ -f ".env" ]]; then
    source ".env"
else
    echo "Credential file .env not found! Exiting."
    exit 1
fi

# Load utility functions
source "config_utils.sh"

# Default to server ID 2 if not provided
SLAVE_SERVER_ID="${SLAVE_SERVER_ID:-2}"

CONFIG_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"
SECTION="mysqld"

##########################################################################
# Backup current config
##########################################################################
timestamp="$(date +%Y%m%d%H%M%S)"
backup_file="${CONFIG_FILE}.bak-${timestamp}"
echo "Backing up $CONFIG_FILE to $backup_file ..."
sudo cp -p "$CONFIG_FILE" "$backup_file"

##########################################################################
# Configure Replica Node
##########################################################################
echo "Configuring MySQL replica settings..."

ensure_config_line "$CONFIG_FILE" "$SECTION" "mysql_native_password = ON"
ensure_config_line "$CONFIG_FILE" "$SECTION" "server-id = $SLAVE_SERVER_ID"
ensure_config_line "$CONFIG_FILE" "$SECTION" "log_bin = mysql-bin"
ensure_config_line "$CONFIG_FILE" "$SECTION" "relay_log = relay-bin"
ensure_config_line "$CONFIG_FILE" "$SECTION" "read_only = 1"
ensure_config_line "$CONFIG_FILE" "$SECTION" "binlog_format = ROW"
ensure_config_line "$CONFIG_FILE" "$SECTION" "gtid_mode = ON"
ensure_config_line "$CONFIG_FILE" "$SECTION" "enforce-gtid-consistency = ON"
ensure_config_line "$CONFIG_FILE" "$SECTION" "relay_log_recovery = ON"
ensure_config_line "$CONFIG_FILE" "$SECTION" "sync_binlog = 1"
ensure_config_line "$CONFIG_FILE" "$SECTION" "innodb_flush_log_at_trx_commit = 1"
ensure_config_line "$CONFIG_FILE" "$SECTION" "log_error = /var/log/mysql/error.log"
ensure_config_line "$CONFIG_FILE" "$SECTION" "binlog_expire_logs_seconds = 345600"

echo "✅ Replica configuration applied successfully."

##########################################################################
# Restart MySQL
##########################################################################
echo "Restarting MySQL (Replica Node)..."
sudo systemctl restart mysql

##########################################################################
# Install Clone Plugin
##########################################################################
echo "Checking if Clone plugin is installed on the Replica..."
PLUGIN_INFO=$(mysql -u"$RECIPIENT_ADMIN_USER" -p"$RECIPIENT_ADMIN_PASS" -N -s \
    -e "SELECT PLUGIN_NAME, PLUGIN_STATUS
        FROM information_schema.PLUGINS
        WHERE PLUGIN_NAME = 'clone';" 2>/dev/null || true)

if [[ -z "$PLUGIN_INFO" ]]; then
    echo "Clone plugin not found on Replica. Installing it..."
    mysql -u"$RECIPIENT_ADMIN_USER" -p"$RECIPIENT_ADMIN_PASS" -e "INSTALL PLUGIN clone SONAME 'mysql_clone.so';"
    echo "✅ Clone plugin installed on Replica."
else
    echo "✅ Clone plugin is already installed on Replica."
fi

echo "🎉 Replica server setup completed successfully!"
