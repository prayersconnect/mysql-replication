#!/bin/bash

##########################################################################
# Function: ensure_config_line
#   - Ensures [mysqld] section exists in the MySQL config file
#   - Removes any existing (commented or not) matching $line in [mysqld]
#   - Appends the line under [mysqld] if not already present
##########################################################################
ensure_config_line() {
    local config_file=$1
    local section=$2    # e.g., "mysqld"
    local line=$3       # e.g., "server-id=1"

    # 1) If there's NO [mysqld] section, append it at the end
    if ! grep -q "^\[$section\]" "$config_file"; then
        echo "[${section}]" | sudo tee -a "$config_file" >/dev/null
    fi

    # 2) Remove any lines (commented or not) that match the line
    sudo sed -i "/^\[$section\]/,/^\[.*\]/{ /${line//\//\\/}/d }" "$config_file"

    # 3) Insert the line after [mysqld]
    sudo sed -i "/^\[$section\]/ a ${line}" "$config_file"
}
