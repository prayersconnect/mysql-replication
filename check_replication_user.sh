#!/bin/bash

source ".env"

echo "Verifying replication user can connect to donor ($DONOR_HOST)..."
MYSQL_PWD="$REPL_PASS" mysql -h "$DONOR_HOST" -u"$REPL_USER" -e "SELECT 1;" &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Access denied for replication user '$REPL_USER' on $DONOR_HOST."
    exit 1
fi

echo "Replication user connection successful."
