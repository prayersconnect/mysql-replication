#!/bin/bash

source ".env"

check_mysql_running() {
    local HOST=$1
    local USER=$2
    local PASS=$3

    echo "Checking if MySQL is running on $HOST..."
    MYSQL_PWD="$PASS" mysqladmin -h "$HOST" -u"$USER" ping &>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "MySQL is not running or credentials are incorrect for $USER@$HOST. Exiting."
        exit 1
    fi
    echo "MySQL is running on $HOST."
}

check_mysql_running "localhost" "$RECIPIENT_ADMIN_USER" "$RECIPIENT_ADMIN_PASS"
check_mysql_running "$DONOR_HOST" "$REPL_USER" "$REPL_PASS"
