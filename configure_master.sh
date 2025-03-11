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

# Default to server ID 1 if not provided
MASTER_SERVER_ID="${MASTER_SERVER_ID:-1}"

CONFIG_FILE="/etc/my.cnf"
SECTION="mysqld"

##########################################################################
# Backup current config
##########################################################################
timestamp="$(date +%Y%m%d%H%M%S)"
backup_file="${CONFIG_FILE}.bak-${timestamp}"
echo "Backing up $CONFIG_FILE to $backup_file ..."
sudo cp -p "$CONFIG_FILE" "$backup_file"

##########################################################################
# Configure Master Node
##########################################################################
echo "Configuring MySQL master settings..."

ensure_config_line "$CONFIG_FILE" "$SECTION" "server-id = $MASTER_SERVER_ID"
ensure_config_line "$CONFIG_FILE" "$SECTION" "log-bin = mysql-bin"
ensure_config_line "$CONFIG_FILE" "$SECTION" "binlog_format = ROW"
ensure_config_line "$CONFIG_FILE" "$SECTION" "binlog_row_image = FULL"
ensure_config_line "$CONFIG_FILE" "$SECTION" "gtid_mode = ON"
ensure_config_line "$CONFIG_FILE" "$SECTION" "enforce-gtid-consistency = ON"
ensure_config_line "$CONFIG_FILE" "$SECTION" "sync_binlog = 1"
ensure_config_line "$CONFIG_FILE" "$SECTION" "innodb_flush_log_at_trx_commit = 1"
ensure_config_line "$CONFIG_FILE" "$SECTION" "expire_logs_days = 7"
ensure_config_line "$CONFIG_FILE" "$SECTION" "log_error = /var/log/mysql/error.log"
ensure_config_line "$CONFIG_FILE" "$SECTION" "binlog_expire_logs_seconds = 345600"
ensure_config_line "$CONFIG_FILE" "$SECTION" "relay_log = relay-bin"
ensure_config_line "$CONFIG_FILE" "$SECTION" "relay_log_recovery = ON"

echo "✅ Master configuration applied successfully."

##########################################################################
# Restart MySQL
##########################################################################
echo "Restarting MySQL (Master Node)..."
sudo systemctl restart mysqld

##########################################################################
# Install Clone Plugin
##########################################################################
echo "Checking if Clone plugin is installed on the Master..."
PLUGIN_INFO=$(mysql -u"$DONOR_ADMIN_USER" -p"$DONOR_ADMIN_PASS" -N -s \
    -e "SHOW PLUGINS LIKE 'clone';" 2>/dev/null || true)

if [[ -z "$PLUGIN_INFO" ]]; then
    echo "Clone plugin not found on Master. Installing it..."
    mysql -u"$DONOR_ADMIN_USER" -p"$DONOR_ADMIN_PASS" -e "INSTALL PLUGIN clone SONAME 'mysql_clone.so';"
    echo "✅ Clone plugin installed on Master."
else
    echo "✅ Clone plugin is already installed on Master."
fi

echo "🎉 Master server setup completed successfully!"
